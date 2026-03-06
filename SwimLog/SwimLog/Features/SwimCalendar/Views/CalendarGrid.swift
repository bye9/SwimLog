//
//  CalendarGrid.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/6/26.
//

import SwiftUI
import Foundation

struct CalendarGrid: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
    
    let selectedMonth: Date
    private let calendar = Calendar.current
    
    var body: some View {
        // 1일 전까지의 빈칸 수
        let startOffset = selectedMonth.firstWeekdayOfMonth(using: calendar) - 1
        
        // 이번 달 총 일수
        let numberOfDays = selectedMonth.numberOfDaysInMonth(using: calendar)
        
        // 전체 그리드 칸 수
        let totalCells = startOffset + numberOfDays
        
        VStack {
            LazyVGrid(columns: columns) {
                // 1. weekDays 배열을 돌면서
                // 2. 각 문자열(day) 그 자체를 고유 식별자로 삼아서
                // 3. Text(day) 뷰를 그려줘.
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            
            LazyVGrid(columns: columns) {
                
                ForEach(0..<totalCells, id: \.self) { index in
                    if index < startOffset {
                        Color.clear.frame(height: 50)
                    } else {
                        let day = index - startOffset + 1
                        
                        Color.blue.frame(height: 50)
                    }
                }
                
            }
        }

        // 7. 7열 그리드에 날짜를 계산해서 뿌리자 (LazyVGrid + ForEach)
        
    }
}

#Preview {
    CalendarGrid(selectedMonth: Date())
}

