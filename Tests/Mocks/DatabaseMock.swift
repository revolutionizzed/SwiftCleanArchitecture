//
//  DatabaseMock.swift
//  SportStorageApp
//
//  Created by David Bocko on 21.02.2025.
//

import SportStorageApp

public class DatabaseMock: DatabaseStorable {
    var storedActivity: SportActivity?
    var fetchedActivities: [SportActivity]
    
    public init(
        fetchedActivities: [SportActivity]? = nil
    ) {
        self.fetchedActivities = fetchedActivities ?? []
    }
    
    public func store(sportActivity: SportActivity) async throws {
        self.storedActivity = sportActivity
    }
    public func fetchAllSportActivities() async throws -> [SportActivity] {
        fetchedActivities
    }
    
    public func delete(sportActivity: SportActivity) async throws {
        let index = fetchedActivities.firstIndex(of: sportActivity)!
        fetchedActivities.remove(at: index)
    }
    

    

}


