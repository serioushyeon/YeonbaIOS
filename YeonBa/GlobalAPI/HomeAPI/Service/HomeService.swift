//
//  HomeService.swift
//  YeonBa
//
//  Created by jin on 5/17/24.
//

import Foundation
import Alamofire

protocol HomeServiceProtocol {
    func arrowCount(bodyDTO: ArrowCountRequest, completion: @escaping (NetworkResult<StatusResponse<ArrowCountResponse>>) -> Void)
    func dailyCheck(bodyDTO: DailyCheckRequest, completion: @escaping (NetworkResult<StatusResponse<String?>>) -> Void)
}

final class HomeService: APIRequestLoader<HomeTarget>, HomeServiceProtocol {
    func arrowCount(bodyDTO: ArrowCountRequest, completion: @escaping (NetworkResult<StatusResponse<ArrowCountResponse>>) -> Void) {
        fetchData(target: .arrowCount(bodyDTO), responseData: StatusResponse<ArrowCountResponse>.self, completion: completion)
    }
    
    func dailyCheck(bodyDTO: DailyCheckRequest, completion: @escaping (NetworkResult<StatusResponse<String?>>) -> Void) {
        fetchData(target: .dailyCheck(bodyDTO), responseData: StatusResponse<String?>.self, completion: completion)
    }
}

