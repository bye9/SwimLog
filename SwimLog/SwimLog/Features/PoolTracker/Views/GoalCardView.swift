//
//  GoalCardView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/28/26.
//

import SwiftUI

struct GoalCardView: View {
    let currentDistanceInKm: Double
    let monthlyGoalDistance: Double
    var progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 1. 상단 섹션: 텍스트 정보와 파도 아이콘
            HStack(alignment: .top) {
                // 텍스트 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text("2월 목표")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(String(format: "%.1f", currentDistanceInKm))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                        Text("/ \(String(format: "%.1f", monthlyGoalDistance)) km")
                            .font(.system(size: 25, weight: .semibold, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                // 물결 아이콘
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 50, height: 50)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x:0, y:5)
                    
                    Image(systemName: "water.waves")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            // 2. 하단 섹션: 진행도 레이블과 프로그레스 바
            VStack(spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.blue.opacity(0.8))
                    
                    Spacer()
                    
                    Text("\(Int(progress*100))%")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.blue.opacity(0.8))
                }
                
                // 프로그레스바
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // 배경 바
                        Capsule()
                            .fill(Color.black.opacity(0.05))
                            .frame(height: 12)
                        
                        // 진행 바
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.4), .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * CGFloat(progress), height: 12)
                            .animation(.spring(), value: progress)
                    }
                }
                .frame(height: 12)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.thickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.05), radius: 20, x: 0, y: 0)
    }
}

#Preview {
    ZStack {
        let viewModel = PoolTrackerViewModel()
        
        Color.blue.opacity(0.1).ignoresSafeArea()
        GoalCardView(currentDistanceInKm: viewModel.currentDistanceInKm, monthlyGoalDistance: viewModel.monthlyGoalDistance, progress: viewModel.progress)
            .padding()
    }
}
