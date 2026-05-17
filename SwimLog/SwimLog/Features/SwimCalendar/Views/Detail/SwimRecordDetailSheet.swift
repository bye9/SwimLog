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
        VStack(alignment: .leading, spacing: 20) {
            if let date = date, let record = filteredRecords.first {
                // 1. 헤더 섹션
                VStack(alignment: .leading, spacing: 4) {
                    // 예: 4월 2일 목요일
                    Text(record.date.formatted(.dateTime.month(.wide).day().weekday(.wide).locale(Locale(identifier: "ko_KR"))))
                        .font(.headline)
                        .padding(.top, 30)
                    
                    // 예: 오후 2:00 - 오후 3:30
                    Text("\(record.date.formatted(.dateTime.hour().minute().locale(Locale(identifier: "ko_KR")))) - \(record.endDate.formatted(.dateTime.hour().minute().locale(Locale(identifier: "ko_KR"))))")
                        .font(.subheadline)
                        .foregroundColor(.cyan)
                        .bold()
                }
                .padding(.horizontal, 20)
                
                // 2. 3개 박스
                HStack(alignment: .center, spacing: 10) {
                    SwimDetailCard(icon: "figure.pool.swim", title: "거리", value: String(format: "%.0f", record.distance), unit: "m")
                        .frame(maxWidth: .infinity)
                    SwimDetailCard(icon: "clock.fill", title: "운동 시간", value: formatDuration(record.duration), unit: "")
                        .frame(maxWidth: .infinity)
                    SwimDetailCard(icon: "gauge.with.needle.fill", title: "평균 페이스", value: formatPace(velocity: record.averagePace), unit: "/100m")
                        .frame(maxWidth: .infinity)
                }
                
                .padding(.horizontal, 16)
                
                // 3. 칼로리 및 심박수
                VStack(spacing: 16) {
                    SwimDetailRow(icon: "flame.fill", iconColor: .orange, title: "Calories", subTitle: "활동 킬로칼로리", value: String(format: "%.0f", record.calories), unit: "kcal")
                    SwimDetailRow(icon: "heart.fill", iconColor: .red, title: "Avg Heart Rate", subTitle: "평균 심박수", value: String(format: "%.0f", record.averageHeartRate), unit: "bpm")
                }
                .padding(.horizontal, 16)
                
                // 맨 아래에 빈 공간을 몰아넣어 상단 요소들을 위로 밀착
                Spacer(minLength: 0)
            } else {
                EmptyStateDetailView()
            }
        }
        .padding(.top, 20) // 상단 여유 공간
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        // 1. 배경을 유리 효과로 변경
        .background(.ultraThinMaterial)
        // 2. 시트 자체의 배경색을 투명하게 해서 뒤가 비치게 함
        .presentationBackgroundInteraction(.enabled) // 필요시 시트 뒤 터치 허용
        .presentationDetents([.medium])
        .presentationDragIndicator(.hidden)
//        .presentationBackground(.red.opacity(0.5))
    }
    
    // 초 단위를 HH:mm:ss 형식으로 변환 (예: 3704초 -> 01:01:44)
    func formatDuration(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional // 00:00:00 형식
        formatter.zeroFormattingBehavior = .pad // 한 자리 숫자일 때 앞에 0을 붙임
        
        return formatter.string(from: seconds) ?? "00:00:00"
    }
    
    // 페이스 계산
    func formatPace(velocity: Double) -> String {
        guard velocity > 0 else { return "0:00" }
        let secondsFor100m = 100.0 / velocity
        let minutes = Int(secondsFor100m) / 60
        let seconds = Int(secondsFor100m) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// 빈 상태 뷰
fileprivate struct EmptyStateDetailView: View {
    let messages = [
        "오늘은 물 밖에서 휴식 중인가요? 🌊",
        "아직 기록이 없어요. 물속으로 뛰어들어 볼까요? 🏊‍♂️",
        "물개도 가끔은 쉬어야죠! 오늘은 충전의 날! 🦭"
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.pool.swim")
                .font(.system(size: 70))
                .foregroundStyle(.quaternary)
                .padding(.top, 140)
            
            Text(messages.randomElement() ?? "기록이 없습니다.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    SwimRecordDetailSheet(date: Date(), allRecords: [SwimRecord(healthKitUUID: UUID(), date: Date(), endDate: Date(), distance: 820, duration: 100, isAppleWatchData: true, calories: 240, averageHeartRate: 132.2, averagePace: 0.83)])
    
//    SwimRecordDetailSheet(date: Date(), allRecords: [])
}
