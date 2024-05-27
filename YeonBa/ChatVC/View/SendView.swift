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
    private var socketURL = NSURL(string: "ws://13.124.72.132:8080/chat/websocket")!
    private let messageDestinationURL = "ws://api.yeonba.co.kr/chat/pub/chat"
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
    init(roomId: Int?) {
        self.roomId = roomId
        super.init(frame: .zero)
        setUI()
        setLayout()
        print("룸아이디:\(roomId ?? 0)")
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
        let accessToken = KeychainHandler.shared.accessToken
        
        var request = URLRequest(url: socketURL as URL)
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        print("Connecting to WebSocket with URL: \(socketURL.absoluteString)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        socketClient.openSocketWithURLRequest(request: request as NSURLRequest, delegate: self)
    }
    @objc func sendMessage() {
            print("메시지 보내기 ")
            guard let message = messageTextField.text, !message.isEmpty else {
                return
            }
            
            let userId = 3
            let userName = "김민솔123"
            let sentAt = DateFormatter().then {
                $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                $0.timeZone = TimeZone(secondsFromGMT: 0)
            }.string(from: Date())
            
            let request: [String: Any] = [
                "roomId": roomId ?? 0,
                "userId": userId,
                "userName": userName,
                "content": message,
                "sentAt": ISO8601DateFormatter().string(from: Date())
            ]
            print("requeest 값\(request)")
            socketClient.sendJSONForDict(dict: request as AnyObject, toDestination: messageDestinationURL)
    }
    
    func showMessageOutput(userId: Int, userName: String, message: String, sentAt: String) {
        let sentAtFormatted = formatDateString(sentAt)
        let newMessage = "User \(userName) (ID: \(userId)): \(message) (at \(sentAtFormatted))\n"
        // messages.text += newMessage
    }
    func formatDateString(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
}

extension SendView: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let body = jsonBody as? [String: Any],
              let roomId = body["roomId"] as? Int,
              let userId = body["userId"] as? Int,
              let userName = body["userName"] as? String,
              let content = body["content"] as? String,
              let sentAt = body["sentAt"] as? String else {
            print("Error parsing JSON message")
            return
        }
        print("jsonBody: \(String(describing: jsonBody))")
        showMessageOutput(userId: userId, userName: userName, message: content, sentAt: sentAt)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("StompClient is connected")
        print("소켓통신: \(String(describing: roomId))")
        
        let topic = "ws://api.yeonba.co.kr/chat/sub/room/\(roomId)"
        client.subscribe(destination: topic)
        
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("StompClient is disconnected")
    }
    
    func stompClientDidReceiveError(client: StompClientLib!, withErrorMessage description: String) {
        print("Received error: \(description)")
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



