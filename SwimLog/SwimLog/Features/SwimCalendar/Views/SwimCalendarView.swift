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
                VStack {
                    HStack(spacing: 20) {
                        Button(action: viewModel.moveToPreviousMonth) {
                            Image(systemName: "chevron.left")
                                .font(.title3.bold())
                        }
                        
                        Text("\(viewModel.selectedMonth, format: .dateTime.year().month())")
                            .font(.title2.bold())
                        
                        Button(action: viewModel.moveToNextMonth) {
                            Image(systemName: "chevron.right")
                                .font(.title3.bold())
                        }
                    }
                    
                    CalendarGrid(viewModel: viewModel)
                }.padding()
            }
            .navigationTitle("수영 기록")
            .background(Color(.systemGroupedBackground))
        }
    }

}

#Preview {
    SwimCalendarView()
}
