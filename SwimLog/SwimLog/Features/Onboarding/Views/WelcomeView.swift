//
//  WelcomeView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 5/28/26.
//

import SwiftUI

struct WelcomeView: View {
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // 일러스트
            Image(systemName: "figure.pool.swim")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .foregroundStyle(.cyan)
                .padding(40)
                .background(
                    Circle()
                        .fill(Color.cyan.opacity(0.1))
                )
            
            // 텍스트
            VStack(spacing: 12) {
                Text("SwimLog")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("애플워치로 기록한 수영을\n한눈에 모아봐요")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            // 시작 버튼
            Button(action: onNext) {
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
    WelcomeView(onNext: {})
}
