//
//  GoalSettingView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct GoalSettingView: View {
    @Binding var monthlyGoal: Double
    let onComplete: () -> Void
    
    private let range: ClosedRange<Double> = 10...500
    private let step: Double = 10
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // 일러스트
            Image(systemName: "target")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
                .foregroundStyle(.cyan)
            
            // 설명
            VStack(spacing: 12) {
                Text("월 목표를 정해볼까요?")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                
                Text("이번 달 목표 수영 거리를 설정해주세요.\n언제든지 설정에서 바꿀 수 있어요.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            // 현재 목표값 표시
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(Int(monthlyGoal))")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(.cyan)
                    .contentTransition(.numericText())
                
                Text("km")
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            
            // 슬라이더
            VStack(spacing: 8) {
                Slider(value: $monthlyGoal, in: range, step: step)
                    .tint(.cyan)
                
                HStack {
                    Text("\(Int(range.lowerBound))km")
                    Spacer()
                    Text("\(Int(range.upperBound))km")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // 완료 버튼
            Button(action: onComplete) {
                Text("시작하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    GoalSettingView(monthlyGoal: .constant(200), onComplete: {})
}
