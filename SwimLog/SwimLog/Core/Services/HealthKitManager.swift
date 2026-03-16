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
        // 읽기 권한을 가질 타입 정의 (운동 기록 및 수영 거리)
        let readDataTypes: Set = [
            HKObjectType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!
        ]
        
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
}
