//
//  SportActivity.swift
//
//  Created by David Bocko on 21.02.2025.
//
import Foundation

public struct SportActivity: Hashable, Codable {
    public let id: String
    public let name: String
    public let location: SportActivityLocation?
    public let duration: TimeInterval?
    public let isLocallyStored: Bool
    
    public init(id: String, name: String, location: SportActivityLocation?, duration: TimeInterval?, isLocallyStored: Bool) {
        self.id = id
        self.name = name
        self.location = location
        self.duration = duration
        self.isLocallyStored = isLocallyStored
    }
}
