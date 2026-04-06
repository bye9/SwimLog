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
    let isSelected: Bool
    let status: DayStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity) // 고정 폭 대신 유연하게
                .aspectRatio(1.0, contentMode: .fit) // 정사각형 유지
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                    // 선택되었을 때만 파란색 테두리, 두께는 약간 두껍게(3)
                        .stroke(isSelected ? Color.cyan.opacity(0.3) : Color.clear)
                )
            
            // 오늘 표시
            VStack(spacing: 2) {
                Text("\(day)")
                    .font(.system(size: 16, weight: isSelected ? .bold : (isToday ? .bold : .medium)))
                    .foregroundStyle(textColor)
                
                if isToday {
                    Circle()
                        .fill(isSelected ? .white : (status == .recorded ? .white : .blue))
                        .frame(width: 4, height: 4)
                } else {
                    // 레이아웃 유지를 위한 투명 공간
                    Spacer().frame(height: 4)
                }
            }
        }
        
    }
    
    private var backgroundColor: Color {
        switch (status, isSelected) {
        case (_, true):
            // 1. 어떤 상태든 '선택'이 최우선이라면
            return Color.cyan.opacity(0.3)
            
        case (.recorded, false):
            // 2. 기록은 있지만 선택되지 않은 상태
            return .cyan
            
        case (.none, false):
            // 3. 기록도 없고 선택도 안 된 기본 상태
            return Color.gray.opacity(0.05)
        }
    }
    
    private var textColor: Color {
        switch (status, isSelected) {
        case (_, true):
            // 배경이 연한 하늘색(opacity 0.3)이므로 글씨는 진한 cyan
            return .cyan
            
        case (.recorded, false):
            // 배경이 진한 cyan이므로 글씨는 하얀색
            return .white
            
        case (.none, false):
            // 기본 상태
            return .gray
        }
    }
}

#Preview {
    SwimCalendarDayCell(day: 5, isToday: true, isSelected: true, status: .recorded)
}
