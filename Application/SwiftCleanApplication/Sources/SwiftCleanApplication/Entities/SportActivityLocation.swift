//
//  SportActivityLocation.swift
//
//  Created by David Bocko on 21.02.2025.
//

public struct SportActivityLocation: Hashable, Codable {
    public let name: String?
    public let longitude: Double?
    public let latitude: Double?
    
    public init(name: String?, longitude: Double?, latitude: Double?) {
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
    }
}
