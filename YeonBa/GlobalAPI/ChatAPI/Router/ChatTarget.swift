//
//  ChatTarget.swift
//  YeonBa
//
//  Created by 김민솔 on 5/18/24.
//

import Foundation
import Alamofire


enum ChatTarget {
    case chattingList
    case chatSend(_ queryDTO: ChatContentRequest)
}

extension ChatTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .chattingList:
            return .get
        case .chatSend:
            return .post
        }
    }
    var path: String {
        switch self {
        case .chattingList:
            return "/chattings"
        case .chatSend:
            return ""
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case .chattingList:
            return .requestPlain
        case let .chatSend(queryDTO):
            return .requestQuery(queryDTO)
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .chattingList:
            return .providerToken
        case .chatSend:
            return .providerToken
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .chattingList:
            return .authorization
        case .chatSend:
            return .authorization
        }
    }

}
