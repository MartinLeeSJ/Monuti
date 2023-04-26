//
//  SetMonthView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/26.
//

import SwiftUI

struct SetMonthView: View {
    @ObservedObject var manager: CalendarManager
    @Binding var isShowing: Bool
    
    var currentYear: String {
        if let firstMonth = manager.currentYearData.first {
            return firstMonth.formatted(Date.FormatStyle().year(.defaultDigits))
        } else {
            return ""
        }
    }
    
    private func convertDateToMonthString(_ date: Date) -> String {
        date.formatted(Date.FormatStyle().month(.abbreviated))
    }
    
    var body: some View {
        Color.black.opacity(0.7)
            .ignoresSafeArea()
            .onTapGesture {
                isShowing.toggle()
            }
            .overlay {
                VStack {
                    HStack {
                        Text(currentYear)
                            .font(.title3.bold())
                        Spacer()
                        
                        Button {
                            manager.handlePreviousButton(.year)
                        } label: {
                            Image(systemName: "chevron.left.circle")
                        }
                        
                        Button {
                            manager.handleNextButton(.year)
                        } label: {
                            Image(systemName: "chevron.right.circle")
                        }
                        
                    }
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 4), spacing: 10) {
                        
                        ForEach(manager.currentYearData, id: \.self) { month in
                            Button {
                                manager.selectDate(month)
                            } label: {
                                Text(convertDateToMonthString(month))
                                    .font(.subheadline)
                                    .padding(.vertical, 10)
                                    .frame(width: 36)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.GTPastelBlue)
                }
                .padding()
            }
    }
}

struct SetMonthView_Previews: PreviewProvider {
    static var previews: some View {
        SetMonthView(manager: CalendarManager(), isShowing: .constant(true) )
    }
}
