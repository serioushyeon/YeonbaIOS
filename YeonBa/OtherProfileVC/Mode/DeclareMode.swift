//
//  DeclareMode.swift
//  YeonBa
//
//  Created by 김민솔 on 3/28/24.
//

import Foundation
import UIKit

enum DeclareMode: Int, CaseIterable {
    case daily
    case weekly
    
    var title: NSAttributedString {
        let attributes: [NSAttributedString.Key: Any]
        let titleString: String
        
        switch self {
        case .daily:
            titleString = "신고하기"
            attributes = [.foregroundColor: UIColor.red]
        case .weekly:
            titleString = "차단하기"
            attributes = [:] // 주간 모드에 대한 특별한 속성은 없습니다
        }
        
        return NSAttributedString(string: titleString, attributes: attributes)
    }
}
