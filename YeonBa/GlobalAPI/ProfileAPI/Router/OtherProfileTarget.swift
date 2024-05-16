//
//  OtherProfileTarget.swift
//  YeonBa
//
//  Created by jin on 5/16/24.
//

import Foundation
import Alamofire


enum OtherProfileTarget {
    case getOtherProfile(_ bodyDTO: OtherProfileRequest)
    case report(_ bodyDTO: ReportRequest)
    case block(_ bodyDTO: BlockRequest)
    case sendArrow(_ bodyDTO: SendArrowRequest)
    case sendChat(_ bodyDTO: SendChatRequest)
    case bookmark(_ bodyDTO: BookmarkRequest)
    case deleteBookmark(_ bodyDTO: BookmarkRequest)
    case userList(_ queryDTO: UserListRequest)
    case recommandUserList(_ queryDTO: RecommandUserListRequest)
}

extension OtherProfileTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .getOtherProfile:
            return .get
        case .report:
            return .post
        case .block:
            return .post
        case .sendArrow:
            return .post
        case .sendChat:
            return .post
        case .bookmark:
            return .post
        case .deleteBookmark:
            return .delete
        case .userList:
            return .get
        case .recommandUserList:
            return .get
        }
        
    }
    
    var path: String {
        switch self {
        case let .getOtherProfile(bodyDTO):
            return "/users/\(bodyDTO.id)"
        case let .report(bodyDTO):
            return "/users/\(bodyDTO.id)/report"
        case let .block(bodyDTO):
            return "/users/\(bodyDTO.id)/block"
        case let .sendArrow(bodyDTO):
            return "/users/\(bodyDTO.id)/arrow"
        case let .sendChat(bodyDTO):
            return "/users/\(bodyDTO.id)/chat"
        case let .bookmark(bodyDTO):
            return "/favorites/\(bodyDTO.id)"
        case let .deleteBookmark(bodyDTO):
            return "/favorites/\(bodyDTO.id)"
        case let .userList(queryDTO):
            return "/users"
        case let .recommandUserList(queryDTO):
            return "/users/recommend"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .getOtherProfile(bodyDTO):
            return .requestPlain
        case let .report(bodyDTO):
            return .requestWithBody(bodyDTO)
        case let .block(bodyDTO):
            return .requestPlain
        case let .sendArrow(bodyDTO):
            return .requestPlain
        case let .sendChat(bodyDTO):
            return .requestPlain
        case let .bookmark(bodyDTO):
            return .requestPlain
        case let .deleteBookmark(bodyDTO):
            return .requestPlain
        case let .userList(queryDTO):
            return .requestQuery(queryDTO)
        case let .report(queryDTO):
            return .requestPlain
        case .recommandUserList:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .getOtherProfile:
            return .plain
        case .report:
            return .plain
        case .block:
            return .plain
        case .sendArrow:
            return .plain
        case .sendChat:
            return .plain
        case .bookmark:
            return .plain
        case .deleteBookmark:
            return .plain
        case .userList:
            return .plain
        case .recommandUserList:
            return .plain
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .getOtherProfile:
            return .unauthorization
        case .report:
            return .unauthorization
        case .block:
            return .unauthorization
        case .sendArrow:
            return .unauthorization
        case .sendChat:
            return .unauthorization
        case .bookmark:
            return .unauthorization
        case .deleteBookmark:
            return .unauthorization
        case .userList:
            return .unauthorization
        case .recommandUserList:
            return .unauthorization
        }
    }
}
