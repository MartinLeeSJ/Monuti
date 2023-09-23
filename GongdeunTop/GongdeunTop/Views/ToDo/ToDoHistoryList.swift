//
//  ToDoHistoryList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/09/21.
//

import SwiftUI

struct ToDoHistoryList: View {
    enum ToDoCompletionState {
        case completed
        case notCompleted
        
        var localizedTitle: LocalizedStringKey {
            switch self {
            case .completed: return "ToDoHistoryList_Completed"
            case .notCompleted: return "ToDoHistoryList_NotCompleted"
            }
        }
    }
    
    private let todoCompletionState: ToDoCompletionState
    private let todos: [ToDo]
    
    init(_ completionState: ToDoCompletionState, todos: [ToDo]) {
        self.todoCompletionState = completionState
        self.todos = todos
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .spacing(of: .twoThird)) {
                    ForEach(todos, id: \.self) { todo in
                        VStack(spacing: .spacing(of: .twoThird)) {
                            HStack {
                                ToDoInfoCell(todo: todo)
                                
                                Text(TimeInterval(todo.timeSpent).todoSpentTimeString)
                            }
                            
                            Divider()
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text(todoCompletionState.localizedTitle))
        }
    }
}

struct ToDoHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        ToDoHistoryList(.completed ,todos: [ToDo.placeholder])
    }
}
