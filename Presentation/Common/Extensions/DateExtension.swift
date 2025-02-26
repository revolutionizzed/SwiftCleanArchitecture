//
//  DateExtension.swift
//  SportStorageApp
//
//  Created by David Bocko on 24.02.2025.
//

import Foundation

public extension Date {
    static var zeroTime: Date {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let midnightDate = calendar.date(from: components) ?? Date()
        return midnightDate
    }
}
