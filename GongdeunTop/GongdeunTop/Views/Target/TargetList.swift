//
//  TargetList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import SwiftUI


struct TargetList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var targetManager: TargetManager
    
    @State private var isDeleteAlertOn: Bool = false
    
    
    var body: some View {
        ZStack {
            themeManager.colorInPriority(in: .background)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                topEditingConsole
                if !targetManager.targets.isEmpty {
                    List(targetManager.targets, id: \.self.id, selection: $targetManager.multiSelection) { target in
                        NavigationLink {
                            TargetDetailView(target: target)
                        } label: {
                            TargetListCell(target: target)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 8,
                                             leading: 16,
                                             bottom: 4,
                                             trailing: 16))
                    }
                    .listStyle(.plain)
                    .environment(\.editMode, .constant(targetManager.isEditing ? EditMode.active : EditMode.inactive))
                }
                
                Spacer()
                Divider()
                
                if targetManager.isEditing {
                    bottomDeleteButton
                }
            }
        }
    }
}

extension TargetList {
    @ViewBuilder
    var topEditingConsole: some View {
        HStack {
            Spacer()
            multipleEditingButton
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .tint(themeManager.colorInPriority(in: .accent))
    }
    
    @ViewBuilder
    private var multipleEditingButton: some View {
        Button {
            withAnimation {
                targetManager.isEditing.toggle()
            }
        } label: {
            Text(targetManager.isEditing ? "Done" : "Edit")
        }
    }
}

// MARK: - Bottom Editing Console
extension TargetList {
    @ViewBuilder
    var bottomDeleteButton: some View {
        HStack {
            Button {
                isDeleteAlertOn.toggle()
            } label: {
                Text("Delete")
            }
            .alert("Delete", isPresented: $isDeleteAlertOn) {
                Button(role: .destructive) {
                    targetManager.removeTargets()
                    isDeleteAlertOn.toggle()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("really_delete_target? \(targetManager.multiSelection.count)")
            }
            
            Spacer()
        }
        .tint(themeManager.colorInPriority(in: .accent))
        .disabled(targetManager.multiSelection.isEmpty)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}


