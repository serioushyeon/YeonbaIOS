//
//  PreferenceCollectionViewCell.swift
//  YeonBa
//
//  Created by 김민솔 on 3/27/24.
//

import UIKit

class PreferenceCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PreferenceCell"

    private let aboutButton =  UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("22살", for: .normal)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(aboutButton)
        aboutButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size = CGSize(width: ceil(size.width), height: ceil(size.height))
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(with title: String) {
        aboutButton.setTitle(title, for: .normal)
        aboutButton.sizeToFit()
        contentView.frame.size = aboutButton.frame.size
    }
    
    
}
