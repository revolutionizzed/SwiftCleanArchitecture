//
//  DatabaseStorable.swift
//
//  Created by David Bocko on 21.02.2025.
//

import Foundation

public protocol DatabaseStorable {
    func store(sportActivity: SportActivity) async throws
    func fetchAllSportActivities() async throws -> [SportActivity]
    func delete(sportActivity: SportActivity) async throws
}
