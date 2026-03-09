//
//  CalendarGrid.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/6/26.
//

import SwiftUI
import Foundation

struct CalendarGrid: View {
    @ObservedObject var viewModel: SwimCalendarViewModel
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            // 요일 헤더
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
            
            // 날짜 그리드
            LazyVGrid(columns: columns) {
                ForEach(viewModel.generateDays()) { dayModel in
                    if let day = dayModel.day {
                        CalendarDay(
                            day: day,
                            isToday: dayModel.isToday,
                            status: dayModel.status)
                    } else {
                        // 시작 전 빈칸 처리
                        Color.clear.frame(height: 44)
                    }
                }
            }
        }
        .padding()
        
    }
}

