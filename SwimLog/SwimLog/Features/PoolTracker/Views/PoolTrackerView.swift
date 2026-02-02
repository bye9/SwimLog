//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
//    @State private var viewModel = PoolTrackerViewModel()
    private let monthlyGoal: Double = 20000
    
    var body: some View {
        ZStack(alignment: .top) {
            // LAYER 1: 수영장 배경 및 레인
            PoolLaneView(progress: 0.5).ignoresSafeArea()
            
            // LAYER 2: 상단 글래스 카드 및 UI 요소
            VStack {
                GoalCardView(current: 10, total: 2000)
                    .padding(20)
            }
        }
    }
}

#Preview {
    PoolTrackerView()
}
