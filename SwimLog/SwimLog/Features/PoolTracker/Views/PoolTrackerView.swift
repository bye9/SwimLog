//
//  PoolTrackerView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct PoolTrackerView: View {
    @StateObject private var viewModel = PoolTrackerViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            // 수영장 배경 및 레인
            PoolLaneView(progress: viewModel.progress).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 상단 글래스 카드 및 UI 요소
                    GoalCardView(
                        currentDistance: viewModel.currentDistance,
                        monthlyGoalDistance: viewModel.monthlyGoalDistance,
                        progress: viewModel.progress
                    )
                    
                    // (선택) 수동 새로고침 버튼
                    Button("데이터 새로고침") {
                        Task {
                            await viewModel.syncWithHealthKit()
                        }
                    }
                }
                .padding()
                
            }
        }
        .onAppear {
            // 앱이 켜지거나 화면이 나타날 때 비동기로 데이터 로드
//            "syncWithHealthKit은 비동기 함수(async function)이기 때문에, 동기 환경인 onAppear에서 호출하려면 새로운 비동기 작업 단위인 Task를 생성해서 그 안에서 실행해야 합니다."
            Task {
                await viewModel.syncWithHealthKit()
            }
        }
    }
}

// MARK: - 3. Calendar Grid
struct CalendarGridd: View {
    let selectedMonth: Date
    
    // 더미 데이터
    let swimDays: Set<Int> = [1, 3, 4, 5, 8, 10, 11, 13, 17, 18, 19]
    let milestones: Set<Int> = [5, 11]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    let weekDays = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        VStack(spacing: 15) {
            // 요일 헤더
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // 날짜 그리드
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...31, id: \.self) { day in
                    CalendarDay(
                        day: day,
                        isSwam: swimDays.contains(day),
                        isMilestone: milestones.contains(day),
                        isToday: day == 22
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
    }
}
// MARK: - Calendar Day Cell
struct CalendarDay: View {
    let day: Int
    let isSwam: Bool
    let isMilestone: Bool
    let isToday: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .frame(height: 50)
            
            if isMilestone {
                Image(systemName: "star.fill")
                    .foregroundColor(.white)
                    .font(.caption)
            } else if isToday {
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    var backgroundColor: Color {
        if isSwam {
            return Color.cyan
        } else if isToday {
            return Color.cyan.opacity(0.3)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
}

#Preview {
//    PoolTrackerView()
    CalendarGridd(selectedMonth: Date())
}
