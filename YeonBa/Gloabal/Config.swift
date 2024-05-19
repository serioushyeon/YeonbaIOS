//
//  Config.swift
//  YeonBa
//
//  Created by 김민솔 on 5/18/24.
//

import Foundation

struct Config {
    static let s3URLPrefix: String = {
        if let prefix = Bundle.main.object(forInfoDictionaryKey: "S3URLPrefix") as? String {
            print("S3URLPrefix successfully retrieved: \(prefix)")
            return prefix
        } else {
            fatalError("S3URLPrefix not set in Info.plist")
        }
    }()
}
