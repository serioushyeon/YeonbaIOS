//
//  ChatMessage.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//

import Foundation
import UIKit

struct ChatMessage {
    let content: String
    let userId: Int
    let sentAt: String
    let userName: String
    
    init(from response: ChatRoomResonse) {
        self.content = response.content
        self.userId = response.userId
        self.sentAt = response.sentAt
        self.userName = response.userName
    }
    // Add this initializer
    init(content: String, userId: Int, sentAt: String, userName: String) {
            self.content = content
            self.userId = userId
            self.sentAt = sentAt
            self.userName = userName
    }
}

