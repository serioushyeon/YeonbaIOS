//
//  ChattingRoomViewController.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//

import UIKit
import SnapKit
import Then
import StompClientLib

class ChattingRoomViewController: UIViewController {
    var roomId: Int?
    var chatUserName: String?
    var partnerProfileImageUrl: String = ""
    var messagesDateString = "yyyy년 MM월 dd일"
    var messages: [ChatRoomResonse] = [] // 채팅 데이터를 저장할 배열
    var sendView = SendView()
    //MARK: - UI Components
    lazy var tableView = UITableView(frame: .zero, style: .grouped).then{
        $0.register(MyMessageCell.self, forCellReuseIdentifier: "MyMessageCell")
        $0.register(OtherMessageCell.self, forCellReuseIdentifier: "OtherMessageCell")
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none // 셀 사이의 구분선을 제거
        // 자동 높이 계산 활성화
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 50 // 셀 높이의 적절한 추정치
        $0.sectionFooterHeight = 0
    }
    //MARK: - Actions
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = chatUserName
        addSubViews()
        configUI()
        loadChatData()
        setupKeyboardDismissal()
        tabBarController?.tabBar.isTranslucent = true
        if let roomId = roomId {
            print("Chat Room ID: \(roomId)")
            sendView.roomId = roomId
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    private func setupKeyboardDismissal() {
        // 키보드가 활성화된 상태에서 화면을 터치했을 때 키보드가 사라지도록 설정합니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UI Layout
    func addSubViews(){
        view.addSubview(sendView)
        view.addSubview(tableView)
    }
    func configUI() {
        sendView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(sendView.snp.top)
        }
    }
    
    func loadChatData() {
        guard let roomId = roomId else { return }
        let requestDTO = ChatRoomIdRequest(roomId: roomId)
        NetworkService.shared.chatService.chatRoomList(queryDTO: requestDTO) { response in
            switch response {
            case .success(let statusResponse):
                guard let data = statusResponse.data else { return }
                
                if let data = statusResponse.data {
                    
                    DispatchQueue.main.async {
                        print("Fetched chatData: \(data)")
                        self.messages = statusResponse.data!
                        print("message카운트:\(self.messages.count)")
                        self.messages.sort { $0.sentAt < $1.sentAt }
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
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }


    // MARK: -- objc
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
           
                UIView.animate(
                    withDuration: 0.3
                    , animations: {
                        self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                    }
                )
            }
    }
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
}
extension ChattingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    // 섹션 수를 반환하는 메서드
    func numberOfSections(in tableView: UITableView) -> Int {
        // 날짜별로 그룹화한 후 그룹의 수를 반환
        let groupedMessages = Dictionary(grouping: messages, by: { $0.sentAt.prefix(10) })
        return groupedMessages.count
    }

    // 각 섹션에 포함된 행 수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 섹션에 해당하는 날짜의 메시지 수를 반환
        let groupedMessages = Dictionary(grouping: messages, by: { $0.sentAt.prefix(10) })
        let keys = Array(groupedMessages.keys).sorted()
        let key = keys[section]
        return groupedMessages[key]?.count ?? 0
    }

    // 섹션 헤더 뷰를 설정하는 메서드
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white

        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"

        // 섹션의 날짜를 설정
        let groupedMessages = Dictionary(grouping: messages, by: { $0.sentAt.prefix(10) })
        let keys = Array(groupedMessages.keys).sorted()
        let key = keys[section]

        if let date = dateFormatter.date(from: String(key)) {
            label.text = dateFormatter.string(from: date)
        } else {
            label.text = String(key)
        }

        label.font = UIFont.pretendardRegular(size: 13)
        label.textColor = UIColor.darkGray
        header.addSubview(label)

        label.snp.makeConstraints { make in
            make.top.equalTo(header.snp.top).offset(19)
            make.bottom.equalTo(header.snp.bottom).offset(-19)
            make.centerX.equalTo(header)
        }

        return header
    }

    // 셀을 구성하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupedMessages = Dictionary(grouping: messages, by: { $0.sentAt.prefix(10) })
        let keys = Array(groupedMessages.keys).sorted()
        let key = keys[indexPath.section]
        let chatMessages = groupedMessages[key] ?? []
        let chatMessage = chatMessages[indexPath.row]

        if chatMessage.userId == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            cell.messageLabel.text = chatMessage.content
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageCell", for: indexPath) as! OtherMessageCell
            cell.messageLabel.text = chatMessage.content
            var profilePhotoUrl = partnerProfileImageUrl
            if !profilePhotoUrl.hasSuffix(".png") {
                profilePhotoUrl += ".png"
            }

            if let url = URL(string: Config.s3URLPrefix + profilePhotoUrl) {
                print("Loading image from URL: \(url)")
                cell.profileImageView.kf.setImage(with: url)
            } else {
                print("Invalid URL: \(Config.s3URLPrefix + profilePhotoUrl)")
            }
            return cell
        }
    }
}

