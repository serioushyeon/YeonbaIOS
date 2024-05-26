//
//  SendView.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//

import Foundation
import UIKit
import SnapKit
import Then
import StompClientLib

final class SendView: UIView {
    var roomId: Int?
    private var socketClient = StompClientLib()
    private var socketURL = NSURL(string: "ws://api.yeonba.co.kr/chat")!

    private let messageTextField = UITextField().then {
        $0.placeholder = "메시지 보내기"
        $0.borderStyle = .none
        $0.backgroundColor = .gray2
        $0.textColor = .customgray4
        $0.font = UIFont.pretendardRegular(size: 13)
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
        $0.textAlignment = .left
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40)) // sendButton의 width와 동일하게 설정
        $0.rightViewMode = .always
    }

    private let sendButton = UIButton().then {
        $0.setImage(UIImage(named: "SendIcon"), for: .normal) // 전송 아이콘 이미지 설정
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }

    init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
        connectToWebSocket()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUI() {
        addSubviews(messageTextField, sendButton)
    }

    func setLayout() {
        messageTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }

        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-35)
            make.centerY.equalTo(messageTextField.snp.centerY)
            make.width.height.equalTo(20) // 아이콘 크기
        }
    }

    func connectToWebSocket() {
        guard let url = URL(string: "ws://api.yeonba.co.kr/chat/websocket") else {
            print("Invalid WebSocket URL")
            return
        }

        let request = NSMutableURLRequest(url: url)
        // 필요한 헤더 추가
        request.setValue("http://api.yeonba.co.kr", forHTTPHeaderField: "Origin")
        request.setValue("Bearer \(KeychainHandler.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        socketClient.openSocketWithURLRequest(request: request, delegate: self)
    }
    @objc func sendMessage() {
        guard let message = messageTextField.text, !message.isEmpty else {
            return
        }
        guard let roomId = roomId else {
            print("Room ID가 설정되지 않았습니다.")
            return
        }
        let userId = KeychainHandler.shared.kakaoUserID
        let userName = KeychainHandler.shared.userName
        let sentAt = DateFormatter().then {
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            $0.timeZone = TimeZone(secondsFromGMT: 0)
        }.string(from: Date())

        let request: [String: Any] = [
            "roomId": roomId,
            "userId": userId,
            "userName": userName,
            "content": message,
            "sentAt": sentAt
        ]
        
        if socketClient.isConnected() {
            let jsonData = try! JSONSerialization.data(withJSONObject: request, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)!
            let destination = "/pub/chat"
            socketClient.sendMessage(message: jsonString, toDestination: destination, withHeaders: nil, withReceipt: nil)
        } else {
            print("WebSocket is not connected.")
        }
    }
}

extension SendView: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String: String]?, withDestination destination: String) {
        print("StompClient received message: \(String(describing: jsonBody))")
    }

    func stompClientDidConnect(client: StompClientLib!) {
        print("StompClient is connected")
        if let roomId = roomId {
            let topic = "/sub/chat/room/\(roomId)"
            client.subscribe(destination: topic)
        }
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        print("StompClient is disconnected")
    }

    func stompClientError(_ client: StompClientLib!, didReceiveErrorMessage description: String) {
        print("StompClient received error: \(description)")
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("StompClient received receipt: \(receiptId)")
    }

    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("StompClient received error message: \(description)")
    }

    func serverDidSendPing() {
        print("StompClient received ping")
    }
}



