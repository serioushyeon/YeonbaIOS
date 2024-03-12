//
//  SearchViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 2/29/24.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControl()
        addSubviews()
        configUI()
        
        
    }
    

    // MARK: - Navigation
    func navigationControl() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.title = "찾아보기"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    func addSubviews() {
        
    }
    func configUI() {
        
    }
    

}
