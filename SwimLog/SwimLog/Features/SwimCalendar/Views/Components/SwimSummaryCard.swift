//
//  SwimSummaryCard.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/13/26.
//

import SwiftUI

struct SwimSummaryCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let iconColor: Color
 
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
            
            VStack(spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(size: 28, weight: .bold))
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.gray.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    SwimSummaryCard(icon: "figure.pool.swim",
                title: "총 수영거리",
                value: "12",
                unit: "km",
                iconColor: .cyan)
}
