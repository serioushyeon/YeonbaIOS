//
//  Notification.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//

import Foundation

struct Notification: Codable {
    let notificationType: String
    let content : String
    let senderId: Int
    let senderProfilePhotoUrl: String
    let senderNickname: String
    let createdAt: String
}
