//
//  MyPageService.swift
//  YeonBa
//
//  Created by 김민솔 on 5/23/24.
//

import Foundation
import Alamofire


protocol MyPageServiceProtocol {
    func myProfile(completion: @escaping (NetworkResult<StatusResponse<ProfileResponse>>) -> Void)
    
}

final class MyPageService: APIRequestLoader<MyPageTarget>, MyPageServiceProtocol {
    func myProfile(completion: @escaping (NetworkResult<StatusResponse<ProfileResponse>>) -> Void) {
        fetchData(target: .myprofile, responseData: StatusResponse<ProfileResponse>.self, completion: completion)
    }
}
