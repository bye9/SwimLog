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
            if let date = date {
                Text(date, style: .date)
                    .font(.headline)
                    .padding(.top, 30)
                
                if filteredRecords.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "figure.pool.swim")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("수영 기록이 없어요")
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // 기록이 있을 때 리스트 표시 (다음 단계에서 고도화)
                    List(filteredRecords) { record in
                        Text("\(String(format: "%.1f", record.distance))km 수영 완료")
                    }
                }
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(uiColor: .systemBackground))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SwimRecordDetailSheet(date: Date(), allRecords: [SwimRecord]())
}
