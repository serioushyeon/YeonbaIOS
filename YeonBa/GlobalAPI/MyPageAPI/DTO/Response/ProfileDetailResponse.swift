//
//  ProfileDetailResponse.swift
//  YeonBa
//
//  Created by jin on 5/27/24.
//

import Foundation

struct ProfileDetailResponse : Codable {
    let profilePhotoUrls : [String]
    let gender : String
    let birth : String
    let height : Int
    let phoneNumber : String
    let nickname : String
    let photoSyncRate : Int
    let bodyType : String
    let job : String
    let mbti : String
}
