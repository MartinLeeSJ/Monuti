//
//  ToDoRow.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/27.
//

import SwiftUI

struct ToDoRow: View {
    let todo: ToDo
    
    var body: some View {
        
            NavigationLink {
//                ToDoDetail()
            } label: {
                HAlignment(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(todo.title)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(todo.content)
                            .font(.callout)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(todo.tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 6)
                                        .background(Capsule().fill(Color.GTDenimNavy))
                                }
                            }
                        }
                    }
                    if todo != .placeholder {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                }
                .padding(12)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.GTDenimBlue)
                }
            }
        
    }
}
