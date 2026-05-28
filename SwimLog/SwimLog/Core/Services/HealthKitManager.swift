//
//  HealthKitManager.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 2/23/26.
//

import HealthKit

// MARK: - Authorization State

enum HealthKitAuthorizationState {
    /// 아직 권한 요청 다이얼로그를 띄운 적 없음 (최초 실행)
    case notRequested
    
    /// 이미 권한 다이얼로그에 응답함 (허용/거부 여부는 알 수 없음 — 프라이버시 보호)
    case requested
    
    /// 이 디바이스는 HealthKit을 지원하지 않음 (iPad, 시뮬레이터 일부 등)
    case healthDataUnavailable
}

// MARK: - Errors

enum HealthKitError: LocalizedError {
    case healthDataUnavailable
    case authorizationFailed(Error)
    case queryFailed(Error)

    var errorDescription: String? {
        switch self {
        case .healthDataUnavailable:
            return "이 기기는 건강 데이터를 지원하지 않습니다."
        case .authorizationFailed(let error):
            return "권한 요청에 실패했습니다: \(error.localizedDescription)"
        case .queryFailed(let error):
            return "데이터 조회에 실패했습니다: \(error.localizedDescription)"
        }
    }
}

final class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // 읽기 권한을 가질 타입 정의
    private let readDataTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType(.distanceSwimming),     // 수영 거리
        HKQuantityType(.heartRate),            // 심박수 추가
        HKQuantityType(.activeEnergyBurned)    // 칼로리(에너지 소모량) 추가
    ]
    
    // MARK: - Authorization
    
    /// 현재 권한 요청 상태를 확인합니다.
    /// 주의: HealthKit은 읽기 권한이 거부됐는지 알려주지 않습니다 (프라이버시 보호).
    /// 따라서 "이미 응답했는가" 정도만 판단 가능합니다.
    func authorizationState() async -> HealthKitAuthorizationState {
        guard HKHealthStore.isHealthDataAvailable() else {
            return .healthDataUnavailable
        }
        
        do {
            let status = try await healthStore.statusForAuthorizationRequest(
                toShare: [],
                read: readDataTypes
            )
            switch status {
            case .shouldRequest:
                return .notRequested
            case .unnecessary, .unknown:
                return .requested
            @unknown default:
                return .requested
            }
        } catch {
            // 상태 확인 실패는 가장 안전한 쪽으로 처리 (다시 요청)
            return .notRequested
        }
    }
    
    /// HealthKit 권한 다이얼로그를 띄웁니다.
    /// 이미 응답한 경우 다이얼로그가 뜨지 않고 즉시 반환됩니다.
    /// 다이얼로그 응답 후에도 실제 권한 허용 여부는 알 수 없습니다 (프라이버시 보호).
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.healthDataUnavailable
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readDataTypes)
        } catch {
            throw HealthKitError.authorizationFailed(error)
        }
    }
    
    // MARK: - Query
    
    /// 지정한 날짜 이후의 수영 워크아웃을 가져옵니다.
    /// 빈 배열이 반환될 수 있고, 이는 (1) 진짜 데이터가 없거나 (2) 권한이 거부됐기 때문일 수 있습니다.
    /// HealthKit은 이 두 경우를 구분해서 알려주지 않습니다.
    ///
    /// 수영 기록 가져오기: 특정 날짜 이후의 수영 세션들을 반환합니다.
    func fetchSwimmingSessions(from date: Date) async throws -> [HKWorkout] {
        // 쿼리 조건: 시작일로부터 현재까지, 운동 유형은 워크아웃
        let predicate = HKQuery.predicateForSamples(
            withStart: date,
            end: Date(),
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                // 에러 발생 시 즉시 중단 및 에러 던지기
                if let error {
                    continuation.resume(throwing: HealthKitError.queryFailed(error))
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
