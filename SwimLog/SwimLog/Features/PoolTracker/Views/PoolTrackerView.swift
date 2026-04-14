//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
    @EnvironmentObject var viewModel: PoolTrackerViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            // 수영장 배경 및 레인
            PoolLaneView(progress: viewModel.progress).ignoresSafeArea()
            
            // 상단 가독성을 위한 부드러운 그라데이션
            LinearGradient(
                colors: [Color(.systemGroupedBackground).opacity(0.8), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 200)
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // 목표 카드 (Glassmorphism 스타일 권장)
                    GoalCardView(
                        title: "\(viewModel.currentMonthString) 목표",
                        currentDistanceInKm: viewModel.currentDistanceInKm,
                        monthlyGoalDistance: viewModel.monthlyGoalDistance,
                        progress: viewModel.progress
                    )
                    .padding(.top, 40)
                }
                .padding(.horizontal)
            }
            .refreshable {
                await viewModel.syncWithHealthKit()
            }
        }
        .onAppear {
            UIRefreshControl.appearance().tintColor = UIColor(Color.blue.opacity(0.3))
            
            Task { await viewModel.syncWithHealthKit() }
        }
    }
}

#Preview {
    @StateObject var poolTrackerViewModel = PoolTrackerViewModel()
    MainTabView()
            .environmentObject(poolTrackerViewModel)
}
