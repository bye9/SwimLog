//
//  PoolTrackerViewModel.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/3/26.
//

import Foundation
import SwiftUI
import SwiftData
import HealthKit

@Observable // macro
@MainActor  // 메인스레드 보장
final class PoolTrackerViewModel {
    // MARK: - State
    // @Published 없어도 자동 추적
    
    /// HealthKit 동기화 진행 상태. UI에서 로딩 인디케이터 표시용.
    var isSyncing: Bool = false
    
    /// HealthKit 동기화 에러. UI에서 알림 표시용.
    var syncError: Error?
    
    // MARK: - Dependencies
    private let healthKitManager = HealthKitManager()
    
    // MARK: - Derived State (records를 입력으로 받아 계산)
    
    /// 현재 월 표시용 문자열 (예: "5월")
    var currentMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월"
        return formatter.string(from: Date())
    }
    
    /// 이번 달 기록만 필터링
    /// records 데이터 소유는 SwiftData로 위임
    /// 호출하는 뷰가 @Query로 records를 가져와서 ViewModel에 넘겨주는 방식
    func currentMonthRecords(from records: [SwimRecord]) -> [SwimRecord] {
        let now = Date()
        return records.filter {
            Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month)
        }
    }
    
    /// 이번 달 총 수영 거리 (meter)
    func currentDistance(from records: [SwimRecord]) -> Double {
        currentMonthRecords(from: records)
            .reduce(0) { $0 + $1.distance }
    }
    
    /// 이번 달 총 수영 거리 (km)
    func currentDistanceInKm(from records: [SwimRecord]) -> Double {
        currentDistance(from: records) / 1000.0
    }
    
    /// 월 목표 달성률 (0.0 ~ 1.0)
    func progress(from records: [SwimRecord], monthlyGoalDistance: Double) -> Double {
        guard monthlyGoalDistance > 0 else { return 0 }
        return min(currentDistanceInKm(from: records) / monthlyGoalDistance, 1.0)
    }
    
    
    // MARK: - HealthKit Sync
    
    /// 권한 다이얼로그만 띄움 (온보딩에서 사용).
    /// 이미 응답했으면 즉시 통과. 허용/거부 여부는 알 수 없음.
    func requestAuthorization() async throws {
        try await healthKitManager.requestAuthorization()
    }
      
    /// HealthKit에서 수영 기록을 가져와 SwiftData에 upsert.
    /// @Attribute(.unique) healthKitUUID 덕분에 중복 삽입 시 자동 update.
    func syncWithHealthKit(context: ModelContext) async {
        isSyncing = true
        syncError = nil
        defer { isSyncing = false }
        
        do {
            // 1. 권한 요청
            try await healthKitManager.requestAuthorization()
            
            // 2. HealthKit에서 최근 1년치 워크아웃 fetch
            let yearAgo = Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()
            let workouts = try await healthKitManager.fetchSwimmingSessions(from: yearAgo)
            
            // 3. 각 워크아웃을 SwimRecord로 변환해서 ModelContext에 upsert
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            
            for workout in workouts {
                let record = makeRecord(from: workout, heartRateType: heartRateType)
                context.insert(record)
            }
            
            try context.save()
        } catch {
            syncError = error
            print("데이터 동기화 실패: \(error.localizedDescription)")
        }
    }
    
    /// HKWorkout → SwimRecord 변환 (순수 함수)
    private func makeRecord(from workout: HKWorkout, heartRateType: HKQuantityType) -> SwimRecord {
        let distanceInMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
        let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
        
        // 평균 페이스: workout metadata에 있으면 사용, 없으면 거리/시간으로 계산
        let averagePace: Double
        if let speedQuantity = workout.metadata?[HKMetadataKeyAverageSpeed] as? HKQuantity {
            averagePace = speedQuantity.doubleValue(for: HKUnit(from: "m/s"))
        } else {
            averagePace = workout.duration > 0 ? (distanceInMeters / workout.duration) : 0
        }
        
        // 평균 심박수: workout 내부 통계에서 추출
        var averageHeartRate: Double = 0
        if let statistics = workout.statistics(for: heartRateType),
           let averageQuantity = statistics.averageQuantity() {
            averageHeartRate = averageQuantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        }
        
        return SwimRecord(
            healthKitUUID: workout.uuid,
            date: workout.startDate,
            endDate: workout.endDate,
            distance: distanceInMeters,
            duration: workout.duration,
            isAppleWatchData: true,
            calories: calories,
            averageHeartRate: averageHeartRate,
            averagePace: averagePace
        )
    }
    
}
