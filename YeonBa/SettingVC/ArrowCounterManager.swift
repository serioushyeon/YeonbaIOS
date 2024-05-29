//
//  ArrowCounterManager.swift
//  YeonBa
//
//  Created by 심규민 on 5/21/24.
//

import Foundation

class ArrowCountManager {
    static let shared = ArrowCountManager()
    private init() {}
    
    private(set) var arrowCount: Int = 0 {
        didSet {
            NotificationCenter.default.post(name: .arrowCountDidChange, object: nil)
        }
    }
    
    func incrementArrowCount(by amount: Int) {
        arrowCount += amount
    }
    
    func setArrowCount(to newValue: Int) {
        arrowCount = newValue
    }
}

extension Notification.Name {
    static let arrowCountDidChange = Notification.Name("arrowCountDidChange")
}

