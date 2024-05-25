//
//  ChatList.swift
//  YeonBa
//
//  Created by 김민솔 on 5/24/24.
//

import Foundation

struct ChatList : Codable {
    let id : Int?
    let partnerName : String?
    let partnerProfileImageUrl : String
    let unreadMessageNumber : Int?
    let lastMessage : String?
    let lastMessageAt : String?
}
