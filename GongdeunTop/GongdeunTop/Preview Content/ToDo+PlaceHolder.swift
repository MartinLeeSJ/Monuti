//
//  ToDo+PlaceHolder.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/27.
//

import Foundation
import FirebaseFirestore



extension ToDo {
    
    static var placeholder: Self {
        let title: String = "할 일을 추가해 보세요"
        let content: String = "이곳에는 세부내용이 표시됩니다"
        let tags: [String] = ["태그도", "간편하게", "추가할 수 있어요"]
        
        return ToDo(title: title, content: content, tags: tags, timeSpent: 0, isCompleted: false, createdAt: Date.now)
    }
}
