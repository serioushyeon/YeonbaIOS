//
//  NSDate.swift
//  YeonBa
//
//  Created by 김민솔 on 5/24/24.
//

import Foundation

extension Date {
    func timeAgoSince(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute], from: date, to: self)
        
        if let years = components.year, years > 0 {
            return "\(years)년 전"
        }
        if let months = components.month, months > 0 {
            return "\(months)달 전"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks)주 전"
        }
        if let days = components.day, days > 0 {
            return "\(days)일 전"
        }
        if let hours = components.hour, hours > 0 {
            return "\(hours)시간 전"
        }
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes)분 전"
        }
        return "방금 전"
    }
}
