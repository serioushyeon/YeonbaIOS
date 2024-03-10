//
//  RecieveCupidViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 3/10/24.
//

import UIKit
import Then
import SnapKit
class RecieveCupidViewController: UIViewController {
    // MARK: - UI Components
    private let bodyStackView = UIStackView().then {
      $0.axis = .vertical
      $0.spacing = 24
    }
    private let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Bigheart")
    }
    private let contentLabel = UILabel().then {
        $0.text = "아직 아무도 없어요.\n 마음에 드는 이성을 찾아 보세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configUI()
       
    }
    // MARK: - UI Layout
    func addSubviews() {
        view.addSubview(bodyStackView)
        [self.heartImage, self.contentLabel]
          .forEach(self.bodyStackView.addArrangedSubview(_:))
    }
    func configUI() {
        self.bodyStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    

}
