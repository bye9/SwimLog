//
//  SwimRecordDetailSheet.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 3/16/26.
//

import SwiftUI

struct SwimRecordDetailSheet: View {
    let date: Date?
    let allRecords: [SwimRecord]
    
    // 선택된 날짜의 기록들만 필터링
    private var filteredRecords: [SwimRecord] {
        guard let date = date else { return [] }
        return allRecords.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let date = date, let record = filteredRecords.first {
                // 1. 헤더 섹션
                VStack(alignment: .leading, spacing: 4) {
                    Text(date, style: .date)
                        .font(.headline)
                        .padding(.top, 30)
                    
                    Text("수영언제했는지")
                        .font(.headline)
                        .foregroundColor(.cyan)
                }
                .padding(.vertical, 10)
                
                // 2. 3개 박스
                HStack(spacing: 12) {
                    SwimDetailCard(icon: "figure.pool.swim", title: "DISTANCE", value: String(format: "%.1f", record.distance / 1000), unit: "km")
                    SwimDetailCard(icon: "clock.fill", title: "DURATION", value: formatDurationToMinutes(record.duration), unit: "m")
                    SwimDetailCard(icon: "gauge.with.needle.fill", title: "AVG PACE", value: "1:50", unit: "/100m")
                }
                .padding(.horizontal, 20)
                
                // 3. 활동량 및 심박수
                VStack(spacing: 16) {
                    SwimDetailRow(icon: "flame.fill", iconColor: .orange, title: "Calories", subTitle: "Total energy burned", value: String(format: "%.0f", record.calories), unit: "kcal")
                    SwimDetailRow(icon: "heart.fill", iconColor: .red, title: "Avg Heart Rate", subTitle: "Consistent effort", value: String(format: "%.0f", record.avgHeartRate), unit: "bpm")
                }
                .padding(.horizontal, 24)
            } else {
                EmptyStateDetailView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // 1. 배경을 유리 효과로 변경
        .background(.ultraThinMaterial)
        // 2. 시트 자체의 배경색을 투명하게 해서 뒤가 비치게 함
        .presentationBackgroundInteraction(.enabled) // 필요시 시트 뒤 터치 허용
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
//        .presentationBackground(.red.opacity(0.5))
    }
    
    // 초 단위를 분 단위로 변환 (예: 2700초 -> 45)
    func formatDurationToMinutes(_ seconds: TimeInterval) -> String {
        return "\(Int(seconds) / 60)"
    }
}

// 빈 상태 뷰
fileprivate struct EmptyStateDetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 100)
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 70))
                .foregroundStyle(.quaternary)
            Text("No swim records for this day.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SwimRecordDetailSheet(date: Date(), allRecords: [SwimRecord(id: UUID(), date: Date(), distance: 24, duration: 100, isAppleWatchData: true, calories: 240, avgHeartRate: 132.2)])
}
