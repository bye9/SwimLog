//
//  SwimCalendarView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI
import SwiftData

struct SwimCalendarView: View {
    @Query(sort: \SwimRecord.date, order: .reverse) private var records: [SwimRecord]
    @State private var swimCalendarViewModel = SwimCalendarViewModel()
    
    var body: some View {
        @Bindable var bindableViewModel = swimCalendarViewModel
        
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Button(action: swimCalendarViewModel.moveToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                                .foregroundStyle(.cyan)
                        }
                        Text(swimCalendarViewModel.selectedMonth.formatted(.dateTime.year().month(.wide).locale(Locale(identifier: "ko_KR"))))
                            .font(.title2.bold())
                        
                        Button(action: swimCalendarViewModel.moveToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title3.bold())
                                .foregroundStyle(.cyan)
                        }
                    }
                    
                    // 캘린더
                    SwimCalendarGridView(viewModel: swimCalendarViewModel, allRecords: records)
                        .gesture(DragGesture(minimumDistance: 30)
                            .onEnded { value in
                                // 1. 왼쪽으로 밀면 다음 달
                                if value.translation.width < -50 {
                                    swimCalendarViewModel.moveToNextMonth()
                                    
                                }
                                // 2. 오른쪽으로 밀면 이전 달
                                else if value.translation.width > 50 {
                                        swimCalendarViewModel.moveToPreviousMonth()
                                }
                            }
                        )
                        .sheet(isPresented: $bindableViewModel.isShowingDetail) {
                            SwimRecordDetailSheet(date: swimCalendarViewModel.selectedDate, allRecords: records)
                        }
                    
                    HStack(spacing: 24) {
                        HStack(alignment: .center, spacing: 8) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.cyan)
                                .frame(width: 18, height: 18)
                            
                            Text("수영 완료🏊")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(alignment: .center, spacing: 5) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.gray.opacity(0.1)) 
                                .frame(width: 18, height: 18)
                            
                            Text("놓쳤다😩")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    
                    
                    // 통계박스
                    HStack(spacing: 16) {
                        let monthRecords = swimCalendarViewModel.currentMonthRecords(allRecords: records)
                        
                        SwimSummaryCard(
                            icon: "figure.pool.swim",
                            title: "총 수영횟수",
                            value: "\(monthRecords.count)",
                            unit: "",
                            iconColor: .cyan
                        )
                        
                        SwimSummaryCard(
                            icon: "location.fill",
                            title: "총 수영거리",
                            value: String(format: "%.1f", swimCalendarViewModel.totalDistance(allRecords: records)),
                            unit: "km",
                            iconColor: .cyan
                        )
                    }
                    
                }.padding()
            }
            .navigationTitle("수영 기록")
            .background(Color(.systemGroupedBackground))
        }
    }

}

#Preview {
    SwimCalendarView()
        .modelContainer(for: SwimRecord.self, inMemory: true)
}
