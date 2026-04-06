//
//  SwimDetailCard.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/17/26.
//

import SwiftUI

struct SwimDetailCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 32, height: 32, alignment: .leading)
                
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(value)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Text(unit)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
        }
        // 1. 상단, 하단, 오른쪽은 12로 고정
        .padding([.top, .bottom, .trailing], 12)
        // 2. 왼쪽만 살짝 더 띄우고 싶다면 (예: 16~20)
        .padding(.leading, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(24)
    }
}

#Preview {
    HStack {
        SwimDetailCard(icon: "figure.pool.swim", title: "DISTANCE", value: "1.2", unit: "km")
        SwimDetailCard(icon: "clock.fill", title: "DURATION", value: "45", unit: "m")
        SwimDetailCard(icon: "gauge.with.needle.fill", title: "AVG PACE", value: "1:50", unit: "/100m")
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
