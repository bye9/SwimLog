//
//  CalendarDay.swift
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

struct CalendarDay: View {
    let day: Int
    let isToday: Bool
    let status: DayStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(width: 44, height: 44)
            
            Text("\(day)")
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
    CalendarDay(day: 5, isToday: true, status: .recorded)
}
