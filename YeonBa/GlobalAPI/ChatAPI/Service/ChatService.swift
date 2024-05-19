//
//  ChatService.swift
//  YeonBa
//
//  Created by 김민솔 on 5/18/24.
//

import Foundation
import Alamofire

protocol ChatServiceProtocol {
    func chatList(completion: @escaping (NetworkResult<StatusResponse<ChatListResponse>>) -> Void)
    
}

final class ChatService: APIRequestLoader<ChatTarget>, ChatServiceProtocol {
    func chatList(completion: @escaping (NetworkResult<StatusResponse<ChatListResponse>>) -> Void) {
        fetchData(target: .chattingList, responseData: StatusResponse<ChatListResponse>.self, completion: completion)
    }
}
