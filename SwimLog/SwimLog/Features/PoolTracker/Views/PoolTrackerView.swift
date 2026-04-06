//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
    @EnvironmentObject var viewModel: PoolTrackerViewModel // 주입된 것 사용
    
    var body: some View {
        ZStack(alignment: .top) {
            // 수영장 배경 및 레인
            PoolLaneView(progress: viewModel.progress).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 상단 글래스 카드 및 UI 요소
                    GoalCardView(
                        currentDistanceInKm: viewModel.currentDistanceInKm,
                        monthlyGoalDistance: viewModel.monthlyGoalDistance,
                        progress: viewModel.progress
                    )
                    
                    // (선택) 수동 새로고침 버튼
                    Button("데이터 새로고침") {
                        Task {
                            await viewModel.syncWithHealthKit()
                        }
                    }
                }
                .padding()
                
            }
        }
        .onAppear {
            // 앱이 켜지거나 화면이 나타날 때 비동기로 데이터 로드
//            "syncWithHealthKit은 비동기 함수(async function)이기 때문에, 동기 환경인 onAppear에서 호출하려면 새로운 비동기 작업 단위인 Task를 생성해서 그 안에서 실행해야 합니다."
            Task {
                await viewModel.syncWithHealthKit()
            }
        }
    }
}

#Preview {
    @StateObject var poolTrackerViewModel = PoolTrackerViewModel()
    MainTabView()
            .environmentObject(poolTrackerViewModel)
}
