//
//  SwimLogApp.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/22/26.
//

import SwiftUI
import SwiftData

@main
struct SwimLogApp: App {
    @State private var poolTrackerViewModel = PoolTrackerViewModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingContainerView()
                }
            }
            // 하위의 모든 뷰가 이 객체를 공유합니다.
            .environment(poolTrackerViewModel)
            .preferredColorScheme(.light)
        }
        .modelContainer(for: SwimRecord.self)
    }
}
