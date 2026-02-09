//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
    @StateObject private var viewModel = PoolTrackerViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            // 수영장 배경 및 레인
            PoolLaneView(progress: viewModel.progress).ignoresSafeArea()
            
            // 상단 글래스 카드 및 UI 요소
            VStack {
                GoalCardView(currentDistance: viewModel.currentDistance, monthlyGoalDistance: viewModel.monthlyGoalDistance, progress: viewModel.progress)
                    .padding(20)
            }
        }
    }
}

#Preview {
    PoolTrackerView()
}
