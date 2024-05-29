import UIKit
import SnapKit
import Then
import Kingfisher

protocol ArrowNotificationCellDelegate: AnyObject {
    func didTapProfileButton(senderId: String)
}
// 화살 알림 셀 (Arrow Notification Cell)
class ArrowNotificationCell: UITableViewCell {
    var notificationModel : [Notifications]?
    var senderId = 0
    weak var delegate: ArrowNotificationCellDelegate?
    // MARK: - UI Components
    let profileImageView = UIImageView().then{
        $0.layer.cornerRadius = 20
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let messageLabel = UILabel().then{
        $0.font = UIFont.pretendardSemiBold(size: 16)
    }
    let actionButton = UIButton().then{
        $0.setTitle("프로필 보러가기", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 17
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1.4
        $0.backgroundColor = UIColor.white
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(profileBtnTapped), for: .touchUpInside)
    }
    let timeLabel = UILabel().then{
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
    
    //MARK: - Actions
    @objc func profileBtnTapped() {
        delegate?.didTapProfileButton(senderId: "\(senderId)")
       
        print("\(notificationModel?.first?.senderId)")
        print("프로필 보러 가기 요청")
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
    
    func configure(with notification: Notifications) {
        messageLabel.text = notification.content
        senderId = notification.senderId
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
