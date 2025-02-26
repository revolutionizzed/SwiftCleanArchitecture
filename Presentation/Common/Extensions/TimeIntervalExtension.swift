//
//  TimeFormatter.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import Foundation

extension  TimeInterval {
    func toFormattedString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self) ?? "0:00"
    }
}
