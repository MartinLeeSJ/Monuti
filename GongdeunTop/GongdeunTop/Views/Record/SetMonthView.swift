//
//  SetMonthView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/26.
//

import SwiftUI

struct SetMonthView: View {
    @Environment(\.colorScheme) var scheme: ColorScheme
    
    @ObservedObject var manager: CalendarManager
    @ObservedObject var cycleStore: CycleStore
    
    @Binding var isShowing: Bool
    
    var currentYear: String {
        if let firstMonth = manager.currentYearData.first {
            return firstMonth.formatted(Date.FormatStyle().year(.defaultDigits))
        } else {
            return ""
        }
    }
    
    private func knowIsSelectedMonth(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: manager.startingPointDate, toGranularity: .month)
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
                            cycleStore.resetAndSubscribe(manager.startingPointDate)
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.title3)
                        }
                        .tint(scheme == .light ? .GTDenimNavy : .white)
                        
                        Button {
                            manager.handleNextButton(.year)
                            cycleStore.resetAndSubscribe(manager.startingPointDate)
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title3)
                        }
                        .tint(scheme == .light ? .GTDenimNavy : .white)
                    }
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 10), count: 4), spacing: 15) {
                        
                        ForEach(manager.currentYearData, id: \.self) { month in
                            Button {
                                manager.selectStartingPointDate(month)
                                cycleStore.resetAndSubscribe(manager.startingPointDate)
                            } label: {
                                VStack {
                                    Spacer()
                                    HAlignment(alignment: .center) {
                                        Text(convertDateToMonthString(month))
                                            .font(.subheadline)
                                            .foregroundColor(knowIsSelectedMonth(month) || scheme == .dark ? .white : .black)
                                    }
                                    Spacer()
                                }
                                .frame(height: 50)
                                .background {
                                    if scheme == .light {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(knowIsSelectedMonth(month) ? Color.GTDenimNavy : Color.white.opacity(0.3))
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(knowIsSelectedMonth(month) ? Color.GTDenimNavy : Color.white.opacity(0.3), lineWidth: 1.5)
                                    }
                                   
                                }
                            }
                            
                        }
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(scheme == .light ? Color.GTPastelBlue : Color.black)
                }
                .overlay {
                    if scheme == .dark {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                    }
                }
                .padding()
            }
    }
}

struct SetMonthView_Previews: PreviewProvider {
    static var previews: some View {
        SetMonthView(manager: CalendarManager(), cycleStore: CycleStore(), isShowing: .constant(true) )
    }
}
