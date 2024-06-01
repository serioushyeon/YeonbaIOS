//
//  NotificationsViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//
import UIKit
import SnapKit
import Then
import Alamofire
class NotificationsViewController: UIViewController, ArrowNotificationCellDelegate, ChatRequestNotificationCellDelegate, ChatGoingNotificationCellDelegate {
    
    
    // MARK: - UI Components
    var notifications : [Notifications] = []
    var notificationId : Int?
    var chatId : Int?
    var chatUserName: String?
    var profileUrl : String?
    let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    let heartImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "Bigheart")
    }
    let contentLabel = UILabel().then {
        $0.text = "알람이 존재하지 않습니다.\n마음에 드는 이성을 찾아 보세요!"
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = UIFont.pretendardSemiBold(size: 20)
    }
    lazy var tableView = UITableView().then {
        $0.register(ArrowNotificationCell.self, forCellReuseIdentifier: "ArrowNotificationCell")
        $0.register(ChatAcceptanceCell.self, forCellReuseIdentifier: "ChatAcceptanceCell")
        $0.register(ChatRequestCell.self, forCellReuseIdentifier: "ChatRequestCell")
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
    }
    let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "알림"
        addSubViews()
        configUI()
        fetchNotifications(page: 1)
    }
    // MARK: - Empty UI Layout
    func addEmptySubviews() {
        view.addSubview(bodyStackView)
        [self.heartImage, self.contentLabel]
            .forEach(self.bodyStackView.addArrangedSubview(_:))
    }
    
    func configEmptyUI() {
        self.bodyStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    // MARK: - UI Layout
    private func addSubViews(){
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    private func configUI() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    // MARK: - Networking
    func fetchNotifications(page: Int) {
        activityIndicator.startAnimating()
        let requestDTO = NotificationPageRequest(page: page)
        NetworkService.shared.notificationService.NotificationList(queryDTO: requestDTO) { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    DispatchQueue.main.async {
                        print("Fetched Notifications: \(data.notifications)")
                        self.activityIndicator.stopAnimating()
                        self.notifications = data.notifications
                        //self.notificationId = data.notifications.first?.notificationId
                        //self.chatId = data.notifications.first?.chatRoomId
//                        self.profileUrl = data.notifications.first?.senderProfilePhotoUrl
//                        if let content = data.notifications.first?.content {
//                            if let nickname = content.components(separatedBy: "님").first {
//                                self.chatUserName = nickname
//                                print("닉네임: \(nickname)")
//                            }
//                        }
                        self.tableView.reloadData()
                        if data.notifications.isEmpty {
                            self.addEmptySubviews()
                            self.configEmptyUI()
                        }
                    }
                }
            default:
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    print("데이터 안들어옴")
                }
            }
        }
    }
    //채팅수락 버튼 눌렀을 시
    func didTapAcceptButton(notificationId: Int) {
        let request = NotificationIdRequest(notificationId: notificationId)
        
        NetworkService.shared.notificationService.notificationChatAccept(queryDTO: request) { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    DispatchQueue.main.async {
                        print("Fetched 채팅수락: \(data)")
                        // notifications 배열에서 해당 알림 삭제
                        if let index = self.notifications.firstIndex(where: { $0.notificationId == notificationId }) {
                            self.notifications.remove(at: index)
                            self.tableView.reloadData()
                        }
                        
                        let chatRoomVC = ChattingRoomViewController()
                        chatRoomVC.roomId = data.chatRoomId
                        chatRoomVC.chatUserName = data.nickname
                        chatRoomVC.partnerProfileImageUrl = data.profilePhotoUrl ?? ""
                        self.navigationController?.pushViewController(chatRoomVC, animated: true)
                    }
                }
            case .requestErr(let statusResponse):
                print("요청 에러: \(statusResponse.message)")
            case .pathErr:
                print("경로 에러")
            case .serverErr:
                print("서버 에러")
            case .networkErr:
                print("네트워크 에러")
            case .failure:
                print("실패")
            }
        }
        
    }
    
    func extractNickname(from content: String) -> String? {
        return content.components(separatedBy: "님").first
    }
    
    func didTapRefuseButton(notificationId: Int) {
        if let index = self.notifications.firstIndex(where: { $0.notificationId == notificationId }) {
            self.notifications.remove(at: index)
            self.tableView.reloadData()
        }
    }
    //MARK: -- 채팅하러 가기 API
    func didTapGoingButton(chatId: Int) {
        if let notification = notifications.first(where: { $0.chatRoomId == chatId }) {
                let chatRoomVC = ChattingRoomViewController()
                chatRoomVC.roomId = chatId
                chatRoomVC.chatUserName = extractNickname(from: notification.content ?? "")
                chatRoomVC.partnerProfileImageUrl = notification.senderProfilePhotoUrl ?? ""
                self.navigationController?.pushViewController(chatRoomVC, animated: true)
            }
    }
    func didTapProfileButton(senderId: String) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.id = senderId
        self.navigationController?.pushViewController(otherProfileVC, animated: true)
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
}

// MARK: - Extensions

extension NotificationsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notifications = notifications[indexPath.row]
        
        switch notifications.notificationType {
        case "ARROW_RECEIVED":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArrowNotificationCell", for: indexPath) as! ArrowNotificationCell
            cell.configure(with: notifications)
            cell.selectionStyle = .none
            cell.delegate = self
            
            return cell
        case "CHATTING_REQUESTED":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRequestCell", for: indexPath) as! ChatRequestCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(with: notifications)
            return cell
        case "CHATTING_REQUEST_ACCEPTED":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatAcceptanceCell", for: indexPath) as! ChatAcceptanceCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(with: notifications)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
