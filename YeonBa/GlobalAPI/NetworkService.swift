//
//  NetworkService.swift
//  YeonBa
//
//  Created by 김민솔 on 5/6/24.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    let signUpService : SignUpServiceProtocol = SignUpService( apiLogger: APIEventLogger())
    let loginService : LoginServiceProtocol = LoginService( apiLogger: APIEventLogger())
    let notificationService : NotificationServiceProtocol = NotificationService( apiLogger: APIEventLogger())
    let otherProfileService : OtherProfileServiceProtocol = OtherProfileService( apiLogger: APIEventLogger())
    let homeService : HomeServiceProtocol = HomeService( apiLogger: APIEventLogger())
    
    private var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        return Session(configuration: configuration, eventMonitors: [APIEventLogger()])
    }()
    
    func setAuthorizationHeader(token: String) {
        sessionManager.sessionConfiguration.headers.add(name: "Authorization", value: "Bearer \(token)")
    }
    
}
