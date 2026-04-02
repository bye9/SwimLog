//
//  PoolTrackerViewModel.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/3/26.
//

import Foundation
import Combine
import HealthKit

class PoolTrackerViewModel: ObservableObject {
    // 거리 데이터
    @Published var records: [SwimRecord] = []
    @Published var monthlyGoalDistance = 200.0
    @Published var currentDistance = 0.0
    
    private var cancellables = Set<AnyCancellable>()
    private let healthKitManager = HealthKitManager()
    
    // 목표 진행률 계산
    var progress: Double {
        monthlyGoalDistance > 0 ? min(currentDistanceInKm / monthlyGoalDistance, 1.0) : 0
    }
    
    // km 변환 프로퍼티
    var currentDistanceInKm: Double {
        return currentDistance / 1000.0
    }
    
    init() {
        // Combine: records 배열이 바뀔 때마다 거리를 합산해서 currentDistance를 자동 업데이트합니다.
        $records
            .map { records in
                // 전체 합계가 아니라 '이번 달' 기록만 필터링해서 합산
                let now = Date()
                return records
                    .filter { Calendar.current.isDate($0.date, equalTo: now, toGranularity: .month) }
                    .reduce(0) { $0 + $1.distance }
            }
            .assign(to: &$currentDistance)
        
        // 2. 테스트용 가짜 데이터 주입 (아까 드린 코드)
            let calendar = Calendar.current
            let now = Date()
            
//            self.records = [
//                SwimRecord(id: UUID(), date: now, distance: 1500, duration: 3000, isAppleWatchData: true),
//                SwimRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -3, to: now)!, distance: 2000, duration: 4000, isAppleWatchData: true),
//                SwimRecord(id: UUID(), date: calendar.date(byAdding: .day, value: -35, to: now)!, distance: 1200, duration: 2500, isAppleWatchData: true)
//            ]
    }
    
    @MainActor
    func syncWithHealthKit() async {
        do {
            // 권한 요청
            let isAuthorized = try await healthKitManager.requestAuthorization()
            
            if isAuthorized {
                // 1년 치 데이터 가져오기
                let yearAgo = Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()
                let workouts = try await healthKitManager.fetchSwimmingSessions(from: yearAgo)
                let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
                
                // HKWorkout 객체를 우리 앱의 SwimRecord 모델로 매핑
                self.records = workouts.map { workout in
                    // 기본 데이터 추출
                    let distanceInMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                    let calories = workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                    let startTime = workout.startDate
                    let endTime = workout.endDate
                    
                    // 평균 페이스(속력) 추출
                    // 애플워치가 계산한 공식 평균 속력이 있다면 가져오고, 없으면 직접 계산
                    let averagePace: Double
                    if let speedQuantity = workout.metadata?[HKMetadataKeyAverageSpeed] as? HKQuantity {
                        averagePace = speedQuantity.doubleValue(for: HKUnit(from: "m/s"))
                    } else {
                        // 속력 = 거리 / 시간
                        averagePace = workout.duration > 0 ? (distanceInMeters / workout.duration) : 0
                    }
                    
                    // 평균 심박수 추출
                    var averageHeartRate: Double = 0
                    
                    // workout 내부에 저장된 심박수 통계 확인
                    if let statistics = workout.statistics(for: heartRateType),
                        let averageQuantity = statistics.averageQuantity() {
                            averageHeartRate = averageQuantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                    }
                    
                    return SwimRecord(
                        id: UUID(),
                        date: startTime,
                        endDate: endTime,
                        distance: distanceInMeters,
                        duration: workout.duration,
                        isAppleWatchData: true,
                        calories: calories,
                        averageHeartRate: averageHeartRate,
                        averagePace: averagePace
                    )
                }
            }
        } catch {
            print("데이터 동기화 실패: \(error.localizedDescription)")
        }
    }
}
