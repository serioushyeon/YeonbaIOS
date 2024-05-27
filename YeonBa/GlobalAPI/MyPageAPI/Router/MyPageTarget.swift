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
    case editProfile(_ bodyDTO: ProfileEditRequest)
    case profileDetail
}

extension MyPageTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .myprofile:
            return .get
        case .editProfile:
            return .patch
        case .profileDetail:
            return .get
        }
        
    }
    
    var path: String {
        switch self {
        case .myprofile:
            return "/users/profiles"
        case .editProfile:
            return "/users/profiles"
        case .profileDetail:
            return "/users/profiles/details"
        }
        
    }
    
    var parameters: RequestParams {
        switch self {
        case .myprofile:
            return .requestPlain
        case let .editProfile(bodyDTO):
            return .requestWithBody(bodyDTO)
        case .profileDetail:
            return .requestPlain
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .myprofile:
            return .hasToken
        case .editProfile:
            return .hasToken
        case .profileDetail:
            return .hasToken
        
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .myprofile:
            return .authorization
        case .editProfile:
            return .authorization
        case .profileDetail:
            return .authorization
        }
    }

}
