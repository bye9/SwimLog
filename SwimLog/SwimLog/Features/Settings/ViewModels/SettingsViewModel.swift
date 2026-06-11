//
//  SettingsViewModel.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 6/5/26.
//

import Foundation
import Combine
import HealthKit
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    // MARK: - Published State
    
    @Published var monthlyGoalDistance: Double
    @Published var authorizationStateText: String = "확인 중..."
    
    // MARK: - Dependencies
    
    private let healthKitManager: HealthKitManager
    private let goalKey = "monthlyGoalDistance"
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(healthKitManager: HealthKitManager = HealthKitManager()) {
        self.healthKitManager = healthKitManager
        
        let saved = UserDefaults.standard.double(forKey: goalKey)
        self.monthlyGoalDistance = saved > 0 ? saved : 200.0
        
        // Combine
        $monthlyGoalDistance
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                UserDefaults.standard.set($0, forKey: self.goalKey)
            }
            .store(in: &cancellables)
    
    }
    
    // MARK: - Actions
    
    /// 현재 HealthKit 권한 상태 확인
    func loadAuthorizationStatus() async {
        let state = await healthKitManager.authorizationState()
        switch state {
        case .notRequested:
            authorizationStateText = "권한 요청 전"
        case .requested:
            authorizationStateText = "권한 요청됨"
        case .healthDataUnavailable:
            authorizationStateText = "이 기기는 지원하지 않음"
        }
    }
    
    /// 설정 앱으로 이동
    func openSettings() {
        guard let url = URL(string: "x-apple-health://") else { return }
        UIApplication.shared.open(url)
    }
    
    /// 앱 버전 정보
     var appVersion: String {
         let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
//         let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
         return "\(version)"
     }
    
}
