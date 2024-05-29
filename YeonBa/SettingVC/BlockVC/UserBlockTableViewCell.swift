//
//  UserBlockTableViewCell.swift
//  YeonBa
//
//  Created by 김민솔 on 5/29/24.
//

import UIKit

class UserBlockTableViewCell: UITableViewCell {
    static let identifier = "UserBlockTableViewCell"
    var blockUserModel : [BlockUsers]?
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "circle.fill") // Use your custom image
        imageView.tintColor = .black
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "박원빈님"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let unblockButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("차단 풀기", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(circleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(unblockButton)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        circleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(circleImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        unblockButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    public func configure(with title: String) {
        titleLabel.text = title
        
        var profilePhotoUrl = blockUserModel?.first?.profileUrl ?? ""
        if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
            print("Loading image from URL: \(url)")
            circleImageView.kf.setImage(with: url)
        } else {
            print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
        }
    }
}
