//
//  SignUpTarget.swift
//  YeonBa
//
//  Created by 김민솔 on 5/6/24.
//

import Foundation
import Alamofire


enum SignUpTarget {
    case signUp(_ bodyDTO: SignUpRequest)
}

extension SignUpTarget: TargetType {
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/join"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .signUp(bodyDTO):
            return .requestWithMultipart(bodyDTO.toMultipartFormData())
        }
    }
    
    var headerType: HTTPHeaderType {
        switch self  {
        case .signUp:
            return .plain
        }
    }
    
    var authorization: Authorization {
        switch self {
        case .signUp:
            return .unauthorization
        }
    }
}
extension SignUpRequest {
    func toMultipartFormData() -> (MultipartFormData) -> Void {
        return { formData in
            formData.append("\(self.socialId)".data(using: .utf8) ?? Data(), withName: "socialId")
            formData.append(self.loginType.data(using: .utf8) ?? Data(), withName: "loginType")
            formData.append(self.gender.data(using: .utf8) ?? Data(), withName: "gender")
            // 나머지 프로퍼티들도 추가
            
            // 프로필 사진을 formData에 추가하는 경우
            if let profilePhotos = self.profilePhotos {
                for (index, photo) in profilePhotos.enumerated() {
                    formData.append(UIImage(named: photo)?.pngData() ?? Data(), withName: "photo\(index)", fileName: "photo\(index).png", mimeType: "image/png")
                }
            }
        }
    }
}

