import UIKit
import SnapKit
import Then
import Kingfisher

protocol ChatRequestNotificationCellDelegate: AnyObject {
    func didTapAcceptButton(notificationId: Int)
}
// 채팅 요청 알림 셀 (Chat Request Cell)
class ChatRequestCell: UITableViewCell {
    weak var delegate: ChatRequestNotificationCellDelegate?
    var notificationId = 0
    //MARK: - UI Components
    let profileImageView = UIImageView().then{
        $0.image = UIImage(named: "woosuck")
        $0.layer.cornerRadius = 20
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let messageLabel = UILabel().then{
        $0.text = "선재님이 채팅을 요청했어요!"
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    let rejectButton = UIButton()
    let actionButton = UIButton().then{
        $0.setTitle("수락", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 17
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.4
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(AcceptBtnTapped), for: .touchUpInside)
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
    
    //MARK: - UI Layout
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
    //MARK: - Actions
    @objc func rejectBtnTapped() {
        print("채팅 거절")
    }
    @objc func AcceptBtnTapped() {
        delegate?.didTapAcceptButton(notificationId: notificationId)
        print("채팅요청 수락")
    }
    func addSubViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(alarmIcon)
        contentView.addSubview(rejectButton)
    }
    func configUI() {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8.34, leading: 10.0, bottom: 8.34, trailing: 10.0)
        rejectButton.configuration = configuration
        
        rejectButton.setTitle("거절", for: .normal)
        rejectButton.setTitleColor(.red, for: .normal)
        rejectButton.setTitleColor(UIColor.black, for: .normal)
        rejectButton.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        rejectButton.layer.cornerRadius = 17
        rejectButton.layer.borderColor = UIColor.black.cgColor
        rejectButton.layer.borderWidth = 1.4
        rejectButton.backgroundColor = UIColor.white
        rejectButton.layer.masksToBounds = true
        rejectButton.addTarget(self, action: #selector(rejectBtnTapped), for: .touchUpInside)
        rejectButton.snp.makeConstraints { make in
            make.centerY.equalTo(actionButton.snp.centerY)
            make.leading.equalTo(actionButton.snp.trailing).offset(10)
        }
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
    func configure(with notification: Notifications) {
        messageLabel.text = notification.content
        notificationId = notification.notificationId ?? 00000
        print("알림내용:\(notification.content)")
        if let dateString = notification.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            var date: Date?
            if dateString.contains(".") {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                date = dateFormatter.date(from: dateString)
            }
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                date = dateFormatter.date(from: dateString)
            }
            
            if let date = date {
                let timeAgo = date.toRelativeString()
                timeLabel.text = timeAgo
            } else {
                timeLabel.text = "Invalid Date"
            }
        }
        var profilePhotoUrl = notification.senderProfilePhotoUrl
        if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
            print("Loading image from URL: \(url)")
            profileImageView.kf.setImage(with: url)
        } else {
            print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
        }
    }
}
