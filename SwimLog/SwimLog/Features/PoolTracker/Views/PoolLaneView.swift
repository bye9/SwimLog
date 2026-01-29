//
//  PoolLaneView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/28/26.
//

import SwiftUI

// 수영장 바닥과 거북이의 움직임
struct PoolLaneView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // 바닥 색상 (White Liquid Glass의 베이스가 되는 맑은 물색)
                Color(red: 0.9, green: 0.96, blue: 1.0)
                
                // 레인 구분선
                HStack(spacing: geo.size.width / 3) {
                    Spacer()
                    laneDivider.frame(width: 2)
                    laneDivider.frame(width: 2)
                    Spacer()
                }
                
                // 거북이 (진행도에 따라 아래에서 위로 이동)
                VStack {
                    Image(systemName: "tortoise.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(-90))
                    // 상단 여백(150)과 하단 여백(100)을 고려한 위치 계산
                        .offset(y: -((geo.size.height - 250) * CGFloat(20)) + 100)
                    Spacer().frame(height: 100)
                }
            }
        }
    }
    
    // 점선 그리기
    private var laneDivider: some View {
        Canvas { context, size in
            context.stroke(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                },
                with: .color(.orange.opacity(0.4)),
                style: StrokeStyle(lineWidth: 2, dash: [10, 8])
            )
        }
    }
}
