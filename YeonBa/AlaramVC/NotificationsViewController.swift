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
                        self.notificationId = data.notifications.first?.notificationId
                        self.chatId = data.notifications.first?.chatRoomId
                        self.tableView.reloadData()
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
    //채팅수락 버튼 눌렀을 시
    func didTapAcceptButton(notificationId: Int) {
        let request = NotificationIdRequest(notificationId: notificationId)
        
        NetworkService.shared.notificationService.notificationChatAccept(queryDTO: request) { response in
            switch response {
            case .success(let statusResponse):
                if let data = statusResponse.data {
                    DispatchQueue.main.async {
                        print("Fetched 채팅수락: \(data)")
                        
//                        let chatRoomVC = ChattingRoomViewController()
//                        self.navigationController?.pushViewController(chatRoomVC, animated: true)
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
    //MARK: -- 채팅하러 가기 API
    func didTapGoingButton(chatId: Int) {
        let chatRoomVC = ChattingRoomViewController()
        chatRoomVC.roomId = chatId
        self.navigationController?.pushViewController(chatRoomVC, animated: true)
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
