//
//  HomeTarget.swift
//  YeonBa
//
//  Created by jin on 5/17/24.
//

import Foundation
import Alamofire


enum HomeTarget {
    case arrowCount(_ bodyDTO: ArrowCountRequest)
    case dailyCheck(_ bodyDTO: DailyCheckRequest)
}

extension HomeTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .arrowCount:
            return .get
        case .dailyCheck:
            return .post
        }
        
    }
    
    var path: String {
        switch self {
        case let .arrowCount:
            return "/users/arrows"
        case let .dailyCheck:
            return "/daily-check"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .arrowCount:
            return .requestPlain
        case let .dailyCheck:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .arrowCount:
            return .plain
        case .dailyCheck:
            return .plain
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .arrowCount:
            return .unauthorization
        case .dailyCheck:
            return .unauthorization
        }
    }
}
