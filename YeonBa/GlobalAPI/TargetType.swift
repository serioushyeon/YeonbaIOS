//
//  TargetType.swift
//  YeonBa
//
//  Created by 김민솔 on 5/3/24.
//

import Foundation

import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters : RequestParams { get }
    var headerType : HTTPHeaderType { get }
    var authorization: Authorization { get }
    
}
extension TargetType {
    var baseURL: String {
        return "https://api.yeonba.co.kr"
    }
    var headers: [String: String]? {
        switch headerType {
        case .plain:
            return [
                HTTPHeaderField.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue
            ]
        case .hasToken:
            return [
            HTTPHeaderField.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue,
            HTTPHeaderField.authentication.rawValue: "Bearer \(KeychainHandler.shared.accessToken)"
            ]
            
        case .refreshToken:
            return [
                HTTPHeaderField.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue,
                HTTPHeaderField.authentication.rawValue: "Bearer \(KeychainHandler.shared.refreshToken)"
            ]
            
        case .providerToken:
            return [
                HTTPHeaderField.contentType.rawValue: HTTPHeaderFieldValue.json.rawValue,
                HTTPHeaderField.providerToken.rawValue: KeychainHandler.shared.providerToken
            ]

        }
    }
}

@frozen
enum RequestParams {
    case requestPlain
    case requestWithBody(_ paramter: Encodable?)
    case requestQuery(_ parameter: Encodable?)
    case requestQueryWithBody(_ queryParameter: Encodable?, bodyParameter: Encodable?)
}

extension Encodable {
    func toDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let jsonData = try? JSONSerialization.jsonObject(with: data),
              let dictionaryData = jsonData as? [String: Any]
        else { return [:] }
        
        return dictionaryData
    }
}
