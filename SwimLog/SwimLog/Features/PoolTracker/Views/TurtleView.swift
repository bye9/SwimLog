//
//  TurtleView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/31/26.
//

import SwiftUI

struct TurtleView: View {
    let progress: Double   // 0.0 ~ 1.0
    
    // 헤엄 모션용 상태
    @State private var isSwimming = false
    // 목표 달성 효과용 상태
    @State private var celebrate = false
    
    private var isGoalReached: Bool {
        progress >= 1.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            let topLimit: CGFloat = 270 // 이 값 아래부터 거북이가 움직임 (카드 영역 확보)
            let bottomLimit = geometry.size.height - geometry.safeAreaInsets.bottom + 30
            let usableHeight = bottomLimit - topLimit
            let yPosition = topLimit + usableHeight * (1 - progress)
            
            Image("Turtle")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                // 헤엄 모션: 살짝 회전 (위아래 까딱)
                .rotationEffect(.degrees(isSwimming ? 8 : -8))
                // 목표 달성 시 커지는 효과
                .scaleEffect(isGoalReached ? 1.3 : 1.0)
                // 목표 달성 시 반짝임
                .shadow(color: isGoalReached ? .yellow.opacity(0.8) : .clear,
                        radius: isGoalReached ? 20 : 0)
                .position(x: width / 2, y: yPosition)
                // progress 변할 때 부드럽게 이동
                .animation(.spring(duration: 0.6), value: progress)
        }
        .onAppear {
            startSwimming()
        }
    }
    
    // 헤엄 모션 시작 (무한 반복)
    private func startSwimming() {
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            isSwimming = true
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.1).ignoresSafeArea()
        TurtleView(progress: 0.0)
    }
}
