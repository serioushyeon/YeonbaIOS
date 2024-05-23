//
//  MyPageTarget.swift
//  YeonBa
//
//  Created by 김민솔 on 5/23/24.
//

import Foundation
import Alamofire

enum MyPageTarget {
    case myprofile
}

extension MyPageTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .myprofile:
            return .get
        }
        
    }
    
    var path: String {
        switch self {
        case .myprofile:
            return "/users/profiles"
        
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case .myprofile:
            return .requestPlain
        
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .myprofile:
            return .hasToken
        
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .myprofile:
            return .authorization
        }
    }

}
