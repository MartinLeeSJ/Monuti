//
//  TargetList.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/13.
//

import SwiftUI


struct TargetList: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var targetStore: TargetStore
    
    @State private var isDeleteAlertOn: Bool = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            topEditingConsole
            List(targetStore.targets, id: \.self.id, selection: $targetStore.multiSelection) { target in
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
            .environment(\.editMode, .constant(targetStore.isEditing ? EditMode.active : EditMode.inactive))
            
            Divider()
            
            if targetStore.isEditing {
                bottomDeleteButton
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
        .tint(themeManager.getColorInPriority(of: .accent))
    }
    
    @ViewBuilder
    private var multipleEditingButton: some View {
        Button {
            withAnimation {
                targetStore.isEditing.toggle()
            }
        } label: {
            Text(targetStore.isEditing ? "Done" : "Edit")
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
                    targetStore.deleteTargets()
                    isDeleteAlertOn.toggle()
                } label: {
                    Text("Delete")
                }
            } message: {
                Text("really_delete_target? \(targetStore.multiSelection.count)")
            }
            
            Spacer()
        }
        .tint(themeManager.getColorInPriority(of: .accent))
        .disabled(targetStore.multiSelection.isEmpty)
        .padding(.horizontal, 24)
        .padding(.vertical, 6)
    }
}


