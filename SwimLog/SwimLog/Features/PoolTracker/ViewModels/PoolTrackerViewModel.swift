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
    
    init() {
        // Combine: records 배열이 바뀔 때마다 거리를 합산해서 currentDistance를 자동 업데이트합니다.
        $records
            .map { $0.reduce(0) { $0 + $1.distance } }
            .assign(to: &$currentDistance)
    }
    
    @MainActor
    func syncWithHealthKit() async {
        do {
            // 권한 요청
            let isAuthorized = try await healthKitManager.requestAuthorization()
            
            if isAuthorized {
                // 이번 달 1일부터 현재까지의 데이터 가져오기
                let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
                let workouts = try await healthKitManager.fetchSwimmingSessions(from: startOfMonth)
                
                // HKWorkout 객체를 우리 앱의 SwimRecord 모델로 매핑
                self.records = workouts.map { workout in
                    let distanceInMeters = workout.totalDistance?.doubleValue(for: .meter()) ?? 0
                    return SwimRecord(
                        id: UUID(),
                        date: workout.startDate,
                        distance: distanceInMeters / 1000.0, // m -> km
                        duration: workout.duration,
                        isAppleWatchData: true
                    )
                }
            }
        } catch {
            print("데이터 동기화 실패: \(error.localizedDescription)")
        }
    }
    
    // 목표 진행률 계산
    var progress: Double {
        monthlyGoalDistance > 0 ? min(currentDistance / monthlyGoalDistance, 1.0) : 0
    }
}
