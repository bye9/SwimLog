//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
    var body: some View {
        ZStack {
            // 배경: 화이트톤 미니멀 그라디언트
            LinearGradient(colors: [.white, Color(white: 0.95)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 상단 수심 정보
                VStack(spacing: 8) {
                    Text("CURRENT DEPTH")
                        .font(.caption2).bold().foregroundStyle(.secondary)
                    Text("1,200m")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                }
                .padding(.top, 50)
                
                Spacer()
                
                // 거북이 캐릭터 (임시)
                Image(systemName: "tortoise.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .foregroundStyle(.blue.opacity(0.6))
                
                Spacer()
            }
        }
    }
    
}
