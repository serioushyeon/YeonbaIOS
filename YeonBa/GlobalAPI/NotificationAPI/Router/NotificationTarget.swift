//
//  NotificationTarget.swift
//  YeonBa
//
//  Created by 김민솔 on 5/15/24.
//

import Foundation
import Alamofire


enum NotificationTarget {
    case unread
    case watchIng(_ queryDTO: NotificationPageRequest)
}

//extension NotificationTarget: TargetType {
//    
//    var method: HTTPMethod {
//        switch self {
//        case .unread:
//            return .get
//        case .watchIng:
//            return .patch
//            
//        }
//        
//    }
//}
