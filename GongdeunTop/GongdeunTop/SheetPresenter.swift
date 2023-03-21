//
//  SheetPresenter.swift
//  GongdeunTop
//
//  Created by Martin on 2023/03/20.
//

import SwiftUI

struct SheetPresenter<Content>: UIViewRepresentable where Content: View {
    let title: String
    let image: UIImage?
    let content: Content
    let isUndimmed: Bool
    let detents: [UISheetPresentationController.Detent]
    
    init(_ title: String, image: UIImage? = nil, detents: [UISheetPresentationController.Detent] = [.medium()], isUndimmed: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.image = image
        self.content = content()
        self.isUndimmed = isUndimmed
        self.detents = detents
    }
    
    func makeUIView(context: UIViewRepresentableContext<SheetPresenter>) -> UIButton {
        let button = UIButton(type: .system)
        if let image {
            button.setImage(image, for: .normal)
        }
        button.setTitle(title, for: .normal)
        
        button.addAction(UIAction { _ in
            let hostingController = UIHostingController(rootView: content)
            let viewController = SheetWrapperController(detents: detents, isUndimmed: isUndimmed)
            
            viewController.addChild(hostingController)
            viewController.view.addSubview(hostingController.view)
            
            hostingController.view.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(UIScreen.main.bounds.height))
            hostingController.didMove(toParent: viewController)
            
            button.window?.rootViewController?.present(viewController, animated: true)
            
        }, for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
    
    func makeCoordinator() -> Void {
        return ()
    }
}

class SheetWrapperController: UIViewController {
    let detents: [UISheetPresentationController.Detent]
    let isUndimmed: Bool
    
    init(detents: [UISheetPresentationController.Detent], isUndimmed: Bool) {
        self.detents = detents
        self.isUndimmed = isUndimmed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No Storyboards")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sheetController = self.presentationController as? UISheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersGrabberVisible = true
            
            if isUndimmed {
                sheetController.largestUndimmedDetentIdentifier = .medium
            }
        }
    }
}
