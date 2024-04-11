//
//  AnimalMode.swift
//  YeonBa
//
//  Created by jin on 4/10/24.
//

import Foundation
import UIKit

enum AnimalMode: Int, CaseIterable {
    case dog
    case cat
    case deer
    case cow
    case fox
    case bear
    
    var title: String {
       
        switch self {
        case .dog:
            return "강아지 상"
        case .cat:
            return "고양이 상"
        case .deer:
            return "사슴 상"
        case .cow:
            return "황소 상"
        case .fox:
            return "여우 상"
        case .bear:
            return "곰 상"
            
        }
        
    }
}
