//
//  TargetToDoStore.swift
//  GongdeunTop
//
//  Created by Martin on 2023/06/13.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

class TargetToDoStore: ObservableObject {
    @Published var target: Target
    @Published var todos: [ToDo] = [] {
        didSet {
            organaizeToDos(in: self.todos)
        }
    }
    @Published var targetDictionary = [Date:Set<ToDo>]()
    @Published var tempDates = [Date]()
    
    private var listenerRegistration: ListenerRegistration?
    private let database = Firestore.firestore()
    
    init(target: Target = Target(title: "",
                                 subtitle: "",
                                 createdAt: Date.now,
                                 startDate: Date.now,
                                 dueDate: Date.now,
                                 todos: [],
                                 achievement: 0,
                                 memoirs: "")) {
        self.target = target
        self.targetDictionary = setDictionaryKeyDates(from: target.startDate, to: target.dueDate)
    }
    
    func unsubscribeToDosOfTarget() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribeToDosOfTargets() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let id = target.id else { return }
        
        if listenerRegistration == nil {
            let query = database.collection("Members")
                .document(uid)
                .collection("ToDo")
                .whereField("relatedTarget", isEqualTo: id)
                .order(by: "createdAt")
    
            listenerRegistration = query.addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "unknown")")
                    return
                }
                
                self.todos = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: ToDo.self)
                }
            }
        }
    }
    
    private func organaizeToDos(in array: [ToDo]) {
        let calendar = Calendar.current
        for todo in array {
            guard let todoDate = calendar.dateInterval(of:.day, for: todo.createdAt)?.start else { continue }
            if let _ = targetDictionary[todoDate] {
                targetDictionary[todoDate]?.insert(todo)
            }
        }
    }
    
    private func setDictionaryKeyDates(from start: Date, to end: Date) -> [Date:Set<ToDo>] {
        let calendar = Calendar.current
        guard var currentDate = calendar.dateInterval(of: .day, for: start)?.start else { return [Date:Set<ToDo>]() }
        guard let endDate = calendar.dateInterval(of: .day, for: end)?.start else { return [Date:Set<ToDo>]() }
        
        var termData = [Date:Set<ToDo>]()
        
        while currentDate < endDate {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { continue }
            termData[currentDate] = Set<ToDo>()
            self.tempDates.append(currentDate)
            currentDate = nextDate
        }
        
        return termData
    }
}
