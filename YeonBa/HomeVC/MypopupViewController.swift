//
//  MypopupViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/6/24.
//

import UIKit
import SnapKit
import Then

class MyPopupViewController: UIViewController {
      private let popupView: MyPopupView
      
      init(title: String, desc: String) {
        self.popupView = MyPopupView(title: title, desc: desc)
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
          $0.edges.equalToSuperview()
        }
      }
  
  required init?(coder: NSCoder) { fatalError() }
}

