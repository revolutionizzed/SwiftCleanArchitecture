//
//  SportActivity.swift
//
//  Created by David Bocko on 21.02.2025.
//
import Foundation

public struct SportActivity: Hashable, Codable {
    let id: String
    let name: String
    let location: SportActivityLocation?
    let duration: TimeInterval?
    let isLocallyStored: Bool
}
