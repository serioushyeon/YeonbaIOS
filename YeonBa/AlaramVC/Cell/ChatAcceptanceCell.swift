//
//  ChatAcceptanceCell.swift
//  YeonBa
//
//  Created by 김민솔 on 5/22/24.
//

import UIKit

class ChatAcceptanceCell: UITableViewCell {
    // MARK: - UI Components
    let profileImageView = UIImageView().then{
        $0.image = UIImage(named: "woosuck")
        $0.layer.cornerRadius = 20
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let messageLabel = UILabel().then{
        $0.text = "선재님이 채팅을 수락했어요!"
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    let actionButton = UIButton().then{
        $0.setTitle("채팅 하러가기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 17
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.4
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(chatBtnTapped), for: .touchUpInside)
    }
    let timeLabel = UILabel().then{
        $0.text = "3분 전"
        $0.font = UIFont.pretendardRegular(size: 13)
        $0.textColor = .lightGray
    }
    let alarmIcon = UIImageView().then {
        $0.image = UIImage(named: "AlarmIcon")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8.34, leading: 10.0, bottom: 8.34, trailing: 10.0)
        actionButton.configuration = configuration
        addSubViews()
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubViews()
        configUI()
    }
    //MARK: - UI Layout
    func addSubViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(alarmIcon)
    }
    
    func configUI() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(40) // Assuming a square image
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(8)
            make.leading.equalTo(messageLabel.snp.leading)
            
        }
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.trailing.equalToSuperview().offset(-20)
        }
        alarmIcon.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
        }
    }
    //MARK: - Actions
    @objc func chatBtnTapped() {
        print("chatBtnTapped tapped")
    }
//    func configure(with notification: Notifications) {
//        messageLabel.text = notification.content
//        timeLabel.text = "\(notification.createdAt.timeAgoSinceDate())"
//        print("알림내용:\(notification.content)")
//        if let url = URL(string: Config.s3URLPrefix + notification.senderProfilePhotoUrl) {
//            print("Loading image from URL: \(url)")
//            profileImageView.kf.setImage(with: url)
//        } else {
//            print("Invalid URL: \(Config.s3URLPrefix + notification.senderProfilePhotoUrl)")
//        }
//    }
    func configure(with notification: Notifications) {
            messageLabel.text = notification.content
            timeLabel.text = "\(notification.createdAt.timeAgoSinceDate())"
            print("알림내용:\(notification.content)")
            
            var profilePhotoUrl = notification.senderProfilePhotoUrl
            if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
                print("Loading image from URL: \(url)")
                profileImageView.kf.setImage(with: url)
            } else {
                print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
            }
        }
}
