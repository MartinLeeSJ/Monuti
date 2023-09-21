//
//  CycleMemoir.swift
//  GongdeunTop
//
//  Created by Martin on 2023/04/17.
//

import SwiftUI



struct CycleMemoir: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme: ColorScheme
    @EnvironmentObject private var themeManager: ThemeManager
    
    @StateObject private var manager: CycleManager
    @FocusState private var editorIsFocused: Bool
    
    init(
        todos: [ToDo],
        timeSetting: TimeSetting
    ) {
        let cycle = Cycle(
            todos: [],
            evaluation: 0,
            memoirs: "",
            sessions: timeSetting.numOfSessions,
            concentrationSeconds: timeSetting.totalConcentrationSeconds,
            refreshSeconds: timeSetting.totalRefreshSeconds,
            totalSeconds: timeSetting.totalSeconds
        )
        
        let cycleManager = CycleManager(cycle: cycle, todos: todos)
        self._manager = StateObject(wrappedValue: cycleManager)
    }
    
    var body: some View {
        GeometryReader { geo in
            themeManager
                .sheetBackgroundColor()
                .ignoresSafeArea()
                
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
            .padding()
        }
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
        case todoList, memoir, evaluation
        
        var localizedTitle: LocalizedStringKey {
            switch self {
            case .todoList: return "concentration_todos_title"
            case .memoir: return "concentration_textEditor_title"
            case .evaluation: return "concentration_evaluation_title"
            }
        }
        
        var localizedSubtitle: LocalizedStringKey {
            switch self {
            case .todoList: return "concentration_todos_subtitle"
            case .memoir: return "concentration_textEditor_subtitle"
            case .evaluation: return "concentration_evaluation_subtitle"
            }
        }
    }
    
    @ViewBuilder
    func titleAndSubTitle(of placement: MemoirTitle) -> some View {
        HAlignment(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                Text(placement.localizedTitle)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(placement.localizedSubtitle)
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
        let gridWidth = geo.size.width * 0.3
        let hexagonRadius = gridWidth / 2.5
        let buttonImageWidth = hexagonRadius * 2 - 8
        
        titleAndSubTitle(of: .evaluation)
        
        Grid(verticalSpacing: .zero) {
            GridRow {
                ForEach(MemoirButton.allCases) { button in
                    Button {
                        manager.evaluateCycle(button.number)
                    } label: {
                        RoundedHexagon(radius: hexagonRadius, cornerAngle: 5)
                            .fill(
                                themeManager
                                    .colorInPriority(
                                        in: ColorPriority(rawValue: button.number) ?? .accent
                                    )
                            )
                            .frame(
                                width: gridWidth,
                                height: gridWidth
                            )
                            .overlay {
                                if manager.cycle.evaluation == button.number {
                                    RoundedHexagon(radius: hexagonRadius, cornerAngle: 5)
                                        .stroke(
                                            scheme == .dark ? .white : themeManager.colorInPriority(in: .accent),
                                            lineWidth: 5
                                        )
                                }
                            }
                            .overlay {
                                Image(button.rawValue)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: buttonImageWidth)
                            }
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
        titleAndSubTitle(of: .memoir)
        
        TextEditor(text: $manager.cycle.memoirs)
            .cornerRadius(10)
            .focused($editorIsFocused)
            .frame(height: geo.size.height * 0.35)
            .background(.thinMaterial ,in: RoundedRectangle(cornerRadius: 10))
    }
}

//MARK: - ToDoList For Memoir
extension CycleMemoir {
    @ViewBuilder
    var toDoListForMemoir: some View {
        Group {
            titleAndSubTitle(of: .todoList)
            
            CycleToDoList(manager: manager, mode: .memoir)
        }
    }
}


//MARK: - Handle Finish
extension CycleMemoir {
    func handleFinish() {
        manager.handleFinishedCycleButton()
        dismiss()
    }
}

struct CycleMemoir_Previews: PreviewProvider {
    static var previews: some View {
        CycleMemoir(todos: [ToDo.placeholder], timeSetting: TimeSetting())
            .environmentObject(ThemeManager())
    }
}
