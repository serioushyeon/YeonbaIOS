//
//  CustomPresentationController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/28/24.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        // ModalView의 크기
        let size = CGSize(width: screenBounds.width,
                          height: screenBounds.height * 0.25)
        // ModalView의 위치
        let origin = CGPoint(x: .zero, y: screenBounds.height * 0.75)
        
        return CGRect(origin: origin, size: size)
    }
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // 화면 전환하며 뷰가 나타날 때 실행할 코드
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        // 화면이 사라질 때 실행할 코드
    }
}
