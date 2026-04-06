//
//  SwimDetailRow.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/17/26.
//

import SwiftUI

struct SwimDetailRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subTitle: String
    let value: String
    let unit: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 48, height: 48)
                .background(iconColor.opacity(0.1))
                .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                Text(subTitle)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                Text(unit)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(24)
    }
}

#Preview {
    VStack(spacing: 16) {
        SwimDetailRow(icon: "flame.fill", iconColor: .orange, title: "Calories", subTitle: "Total energy burned", value: "420", unit: "kcal")
        SwimDetailRow(icon: "heart.fill", iconColor: .red, title: "Avg Heart Rate", subTitle: "Consistent effort", value: "135", unit: "bpm")
    }
    .padding(.horizontal, 24)
}
