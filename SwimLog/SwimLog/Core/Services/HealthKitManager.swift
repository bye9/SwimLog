//
//  HealthKitManager.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/23/26.
//

import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    /// 1. 권한 요청: 건강 데이터 접근 승인을 받습니다.
    func requestAuthorization() async throws -> Bool {
        // 읽기 권한을 가질 타입 정의
        let readDataTypes: Set = [
            HKObjectType.workoutType(),
            HKQuantityType(.distanceSwimming),     // 수영 거리
            HKQuantityType(.heartRate),            // 심박수 추가
            HKQuantityType(.activeEnergyBurned)    // 칼로리(에너지 소모량) 추가
        ]
        
        // 비동기로 권한 요청
        try await healthStore.requestAuthorization(toShare: [], read: readDataTypes)
        
        return true
    }
    
    /// 2. 수영 기록 가져오기: 특정 날짜 이후의 수영 세션들을 반환합니다.
    func fetchSwimmingSessions(from date: Date) async throws -> [HKWorkout] {
        // 쿼리 조건: 시작일로부터 현재까지, 운동 유형은 워크아웃
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, error in
                // 에러 발생 시 즉시 중단 및 에러 던지기
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                // 샘플 데이터를 HKWorkout으로 캐스팅 후 '수영'만 필터링
                let workouts = (samples as? [HKWorkout])? .filter { $0.workoutActivityType == .swimming} ?? []

                // 성공적으로 데이터 반환
                continuation.resume(returning: workouts)
            }
            
            healthStore.execute(query)
        }
    }
    
    func fetchAvgHeartRate(for workout: HKWorkout) async -> Double? {
        let heartRateType = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(withStart: workout.startDate, end: workout.endDate, options: .strictStartDate)
        
        let heartRatePredicate = HKSamplePredicate.quantitySample(type: heartRateType, predicate: predicate)
        let descriptor = HKStatisticsQueryDescriptor(predicate: heartRatePredicate, options: .discreteAverage)
        
        do {
            let statistics = try await descriptor.result(for: healthStore)
            return statistics?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min"))
        } catch {
            print("심박수 쿼리 실패: \(error)")
            return nil
        }
    }
}
