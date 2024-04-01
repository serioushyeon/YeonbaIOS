//
//  SearchResultCollectionViewCell.swift
//  YeonBa
//
//  Created by 김민솔 on 4/1/24.
//

import UIKit
import Then
import SnapKit
import Charts

class SearchResultCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "searchResultCell"
    private let cupidImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    private let favoriteBtn = UIButton().then {
        $0.setImage(UIImage(named: "WhiteFavorites"), for: .normal)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadImage()
        addSubview()
        configUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addSubview() {
        contentView.addSubview(cupidImageView)
        contentView.addSubview(favoriteBtn)
    }
    private func configUI() {
        cupidImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        favoriteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    private func loadImage() {
        guard let url = URL(string:"https://static.news.zumst.com/images/58/2023/10/23/0cb287d9a1e2447ea120fc5f3b0fcc11.jpg") else { return }
        cupidImageView.kf.setImage(with: url)
    }
    
}
