//
//  SwimCalendarDayCell.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/6/26.
//

import SwiftUI

// 1. 날짜의 상태를 정의합니다.
enum DayStatus {
    case none       // 아무 기록 없음
    case recorded   // 기록 있음 (수영 완료)
//    case milestone  // 특별한 달성 기록
}

struct SwimCalendarDayCell: View {
    let day: Int
    let isToday: Bool
    let status: DayStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity) // 고정 폭 대신 유연하게
                .aspectRatio(1.0, contentMode: .fit) // 정사각형 유지
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
                )
            
            Text("\(day)")
                .font(.system(size: 16, weight: isToday ? .bold : .medium))
                .foregroundStyle(textColor)
        }
        
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none: return Color.gray.opacity(0.05)
        case .recorded: return .cyan
        }
    }
    
    private var textColor: Color {
        switch status {
        case .none: return .gray
        case .recorded: return .white
        }
    }
}

#Preview {
    SwimCalendarDayCell(day: 5, isToday: true, status: .recorded)
}
