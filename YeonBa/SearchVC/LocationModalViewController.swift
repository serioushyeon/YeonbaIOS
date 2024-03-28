//
//  LocationModalViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/19/24.
//

import UIKit
import Then
import SnapKit

class LocationModalViewController: UIViewController {
    private let AllLabel = UILabel().then {
        $0.text = "지역"
        $0.textColor = UIColor.black
        $0.textAlignment = .center
        $0.font = UIFont.pretendardSemiBold(size: 26)
    }
    private let searchView = UIView().then {
        $0.backgroundColor = UIColor.gray3
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
//    private let searchButton = UIButton().then {
//        
//    }
    let locations: [String]
        init(locations: [String]) {
            self.locations = locations
            super.init(nibName: nil, bundle: nil)

    }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20 // 모달 창의 테두리를 둥글게 설정
        view.layer.masksToBounds = true
                
    }
    func addSubviews() {
        view.addSubview(AllLabel)
        view.addSubview(searchView)
    }
    func configUI() {
        AllLabel.snp.makeConstraints {
        $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        $0.leading.equalToSuperview().inset(20)
        $0.height.equalTo(35)
            
        }
        searchView.snp.makeConstraints {
            $0.top.equalTo(AllLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(51)
        }
       
    }
    

}
