//
//  ModalSelectCell.swift
//  YeonBa
//
//  Created by 김민솔 on 3/28/24.
//

import UIKit
import SnapKit

final class ModeSelectCell: UITableViewCell {
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "declareBtn")
        return imageView
    }()
    private let boxOfficeLabel: UILabel = DeclarLabel(font: .body)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(label: NSAttributedString, isChecked: Bool) {
        boxOfficeLabel.attributedText = label // NSAttributedString으로 설정
        checkImageView.isHidden = !isChecked
    }
}

// MARK: Setup Layout
private extension ModeSelectCell {
    
    func addSubviews() {
        addSubview(boxOfficeLabel)
        addSubview(checkImageView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            boxOfficeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            boxOfficeLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                                constant: 16),
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -16),
        ])
    }
}
