//
//  CycleMemoir.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import SwiftUI



struct CycleMemoir: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var scheme: ColorScheme
    
    
    @StateObject var manager = CycleManager()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var timerManager: TimerManager
    
    @FocusState var editorIsFocused: Bool
    
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    
                    getMemoirButtons(geo)
                    
                    Divider()
                    
                    getTextEditor(geo)
                    
                    Divider()
                    
                    if !manager.todos.isEmpty {
                        toDoListForMemoir
                    }
                    
                    Spacer()
                        .frame(height: 35)
                }
            }
        }
        .padding()
        .interactiveDismissDisabled()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("cycleMemoir_Quit")
                }
            }
            
            ToolbarItem {
                Button {
                    handleFinish()
                } label: {
                    Text("cycleMemoir_Add")
                }
                .disabled(!manager.modified)
            }
        }
        .onTapGesture {
            editorIsFocused = false
        }
    }
}

//MARK: - Title and Subtitle
extension CycleMemoir {
    enum MemoirTitle: String {
        case todos = "todos", textEditor, evaluation
        
        var localizedTitle: String {
            switch self {
            case .todos: return String(localized: "concentration_todos_title")
            case .textEditor: return String(localized: "concentration_textEditor_title")
            case .evaluation: return String(localized: "concentration_evaluation_title")
            }
        }
        
        var localizedSubtitle: String {
            switch self {
            case .todos: return String(localized: "concentration_todos_subtitle")
            case .textEditor: return String(localized: "concentration_textEditor_subtitle")
            case .evaluation: return String(localized: "concentration_evaluation_subtitle")
            }
        }
    }
    
    @ViewBuilder
    func getTitleAndSubTitle(_ placement: String) -> some View {
        HAlignment(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                Text(MemoirTitle(rawValue: placement)?.localizedTitle ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(MemoirTitle(rawValue: placement)?.localizedSubtitle ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//MARK: - Memoir Buttons Grid
extension CycleMemoir {
    
    enum MemoirButton: String, CaseIterable, Identifiable {
        case sand = "sand", brick, steel
        
        var id: Self { self }
        
        var number: Int {
            switch self {
            case .sand: return 1
            case .brick: return 2
            case .steel: return 3
            }
        }
        
        var message: String {
            switch self {
            case .sand: return String(localized: "Weak")
            case .brick: return String(localized: "Good")
            case .steel: return String(localized: "Solid")
            }
        }
    }
    
    @ViewBuilder
    func getMemoirButtons(_ geo: GeometryProxy) -> some View {
        Grid(verticalSpacing: 3) {
            GridRow {
                getTitleAndSubTitle("evaluation")
                .gridCellColumns(3)
            }
            
            GridRow {
                ForEach(MemoirButton.allCases) { button in
                    Button {
                        manager.cycle.evaluation = button.number
                    } label: {
                        Image("\(button.rawValue)\(manager.cycle.evaluation == button.number ? ".clicked" : "" )\(scheme == .dark ? ".dark" : "")")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.31)
                    }
                }
            }
            
            GridRow {
                ForEach(MemoirButton.allCases) { button in
                    Text(button.message)
                        .foregroundColor(manager.cycle.evaluation == button.number ? Color("basicFontColor") : .secondary)
                }
            }
            
        }
    }
}

//MARK: - TextEditor
extension CycleMemoir {
    @ViewBuilder
    func getTextEditor(_ geo: GeometryProxy) -> some View {
        Group {
            getTitleAndSubTitle("textEditor")
            
            VStack {
                TextEditor(text: $manager.cycle.memoirs)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                    }
                    .padding(5)
                    .focused($editorIsFocused)
            }
            .frame(height: geo.size.height * 0.35)
        }
    }
}

//MARK: - ToDoList For Memoir
extension CycleMemoir {
    
    
    @ViewBuilder
    var toDoListForMemoir: some View {
        Group {
            getTitleAndSubTitle("todos")
            
            CycleToDoList(manager: manager, mode: .memoir)
        }
    }
}


//MARK: - Handle Finish
extension CycleMemoir {
    func handleFinish() {
//        manager.recordCycleTimeSetting(timeSetting: timerManager.timeSetting,
//                                       minutes: timerManager.getTotalMinute())
        manager.handleFinishedCycleButton()
        dismiss()
        
    }
}

struct CycleMemoir_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CycleMemoir(timerManager: TimerManager())
                .environment(\.locale, .init(identifier: "en"))
            
            CycleMemoir(timerManager: TimerManager())
                .environment(\.locale, .init(identifier: "ko"))
        }
    }
}
