//
//  SwimCalendarView.swift
//  SwimLog
//
//  Created by JeongHwan Seok on 1/23/26.
//

import SwiftUI

struct SwimCalendarView: View {
    @StateObject private var viewModel = SwimCalendarViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("\(viewModel.selectedMonth, format: .dateTime.year().month())")
                        .font(.headline)
                    
                    CalendarGrid(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("수영 기록")
            .background(Color(.systemGroupedBackground))
        }
    }

}

#Preview {
    SwimCalendarView()
}
