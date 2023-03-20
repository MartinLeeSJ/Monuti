//
//  MyView.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import SwiftUI

struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyViewController
   
    func makeUIViewController(context: Context) -> MyViewController {
        let vc = MyViewController()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MyViewController, context: Context) {
        
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}
