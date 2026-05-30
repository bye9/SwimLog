//
//  OnboardingContainerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("monthlyGoalDistance") private var savedMonthlyGoal: Double = 200.0
    
    @State private var currentPage: Int = 0
    @State private var monthlyGoalInput: Double = 200.0
    
    var body: some View {
        VStack(spacing: 0) {
            // 커스텀 페이지 인디케이터
            PageIndicator(currentPage: currentPage, totalPages: 3)
                .padding(.bottom, 20)
            
            TabView(selection: $currentPage) {
                WelcomeView(onNext: goToNext)
                    .tag(0)
                PermissionView(onNext: goToNext)
                    .tag(1)
                GoalSettingView(
                    monthlyGoal: $monthlyGoalInput,
                    onComplete: completeOnboarding
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func goToNext() {
        withAnimation {
            currentPage += 1
        }
    }
    
    private func completeOnboarding() {
        savedMonthlyGoal = monthlyGoalInput
        hasCompletedOnboarding = true
    }
}

// MARK: - Page Indicator

private struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
    }
}


#Preview {
    OnboardingContainerView()
        .environment(PoolTrackerViewModel())
}
