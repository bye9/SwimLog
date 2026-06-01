//
//  PoolLaneView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/28/26.
//

import SwiftUI

struct PoolLaneView: View {
    let progress: Double // 0.0 ~ 1.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // 1. 수영장 바닥 (그리드 타일 + T라인)
                poolFloor(size: geo.size)
                
                // 2. 수영장 레인 (양옆 두 줄)
                HStack(spacing: geo.size.width * 0.6) {
                    laneDivider
                    laneDivider
                }
            }
        }
    }

    // MARK: - 바닥 타일 및 가이드라인
    private func poolFloor(size: CGSize) -> some View {
        Canvas { context, size in
            // 배경 물색
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color(red: 0.5, green: 0.8, blue: 1.0)))
            
            // 가느다란 격자 타일 무늬
            let gridStep: CGFloat = 20
            let centerX = size.width / 2
            var gridPath = Path()
            
            // 수직 격자선: 중앙(centerX)에서 시작하여 양옆으로 그림
            // 오른쪽 방향
            for x in stride(from: centerX, through: size.width, by: gridStep) {
                gridPath.move(to: CGPoint(x: x, y: 0))
                gridPath.addLine(to: CGPoint(x: x, y: size.height))
            }
            // 왼쪽 방향
            for x in stride(from: centerX, through: 0, by: -gridStep) {
                gridPath.move(to: CGPoint(x: x, y: 0))
                gridPath.addLine(to: CGPoint(x: x, y: size.height))
            }
            // 수평 격자선: 상단에서 하단으로
            for y in stride(from: 0, through: size.height, by: gridStep) {
                gridPath.move(to: CGPoint(x: 0, y: y))
                gridPath.addLine(to: CGPoint(x: size.width, y: y))
            }

            // 중앙 진한 파란색 T-Line
            let tLineWidth: CGFloat = gridStep * 2 // 격자 2칸 너비 (40)
            let tLineColor = Color(red: 0.1, green: 0.2, blue: 0.5)
            // T-Line 높이를 격자선(gridStep)의 배수로 맞춤 (예: 하단에서 약 140 지점의 격자선)
            let tLineYPosition = CGFloat(Int((size.height - 140) / gridStep)) * gridStep

            var tPath = Path()
            // 수직선: 중앙에 딱 맞게 배치
            tPath.addRect(CGRect(x: centerX - tLineWidth/2, y: 0, width: tLineWidth, height: tLineYPosition))
            // 하단 가로선: 격자 칸에 맞춰 너비 120 (격자 6칸)
            tPath.addRect(CGRect(x: centerX - 60, y: tLineYPosition, width: 120, height: tLineWidth))

            context.fill(tPath, with: .color(tLineColor))

            context.stroke(gridPath, with: .color(.white.opacity(0.3)), style: StrokeStyle(lineWidth: 1))
        }
    }

    // MARK: - 4색 레인 (흰-남-빨-노)
    private var laneDivider: some View {
        Canvas { context, size in
            let path = Path { path in
                path.move(to: CGPoint(x: size.width/2, y: 0))
                path.addLine(to: CGPoint(x: size.width/2, y: size.height))
            }
            
            // 이미지처럼 반복되는 4색 패턴 (흰색, 남색, 빨간색, 노란색)
            let laneWidth: CGFloat = 10
            let pattern: [CGFloat] = [100, 300] // 각 색상별 길이
            
            // 1. 흰색 구간
            context.stroke(path, with: .color(.white),
                           style: StrokeStyle(lineWidth: laneWidth, dash: pattern, dashPhase: 0))
            
            // 2. 남색 구간
            context.stroke(path, with: .color(Color(red: 0.1, green: 0.2, blue: 0.4)),
                           style: StrokeStyle(lineWidth: laneWidth, dash: pattern, dashPhase: -100))
            
            // 3. 빨간색 구간
            context.stroke(path, with: .color(.red),
                           style: StrokeStyle(lineWidth: laneWidth, dash: pattern, dashPhase: -200))
            
            // 4. 노란색 구간
            context.stroke(path, with: .color(.yellow),
                           style: StrokeStyle(lineWidth: laneWidth, dash: pattern, dashPhase: -300))
        }
        .frame(width: 20)
    }
}

#Preview {
    PoolLaneView(progress: 0.5)
}
