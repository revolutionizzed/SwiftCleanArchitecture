//
//  SportStorageAppTests.swift
//
//  Created by David Bocko on 21.02.2025.
//

import Testing
import Foundation
@testable import SportStorageApp

struct SportStorageAppTests {

    @Test func storeSportActivity() async throws {
        let localStorageMock = DatabaseMock()
        
        let storeUseCase = StoreSportActivityUseCase(
            localStorage: localStorageMock,
            remoteStorage: localStorageMock
        )
        
        let sportActivity = SportActivity(id: "", name:"Test", location: nil, duration: 100, isLocallyStored: true)
        
        try await storeUseCase.store(sportActivity: sportActivity)
        
        #expect(localStorageMock.storedActivity?.name == "Test")
        #expect(localStorageMock.storedActivity?.duration == 100)
    }
    
    @Test func fetchAllSportActivities() async throws {
        let localStorageMock = DatabaseMock(fetchedActivities: [
            SportActivity(id: "", name:"Test1", location: nil, duration: 101, isLocallyStored: true),
            SportActivity(id: "", name:"Test2", location: nil, duration: 102, isLocallyStored: true)
        ])
        
        let remoteStorageMock = DatabaseMock(fetchedActivities: [
            SportActivity(id: "", name:"Test4", location: nil, duration: 104, isLocallyStored: true),
            SportActivity(id: "", name:"Test5", location: nil, duration: 105, isLocallyStored: true),
            SportActivity(id: "", name:"Test6", location: nil, duration: 106, isLocallyStored: true)
        ])
        
        let sportUseCase = FetchSportActivityUseCase(
            localStorage: localStorageMock,
            remoteStorage: remoteStorageMock
        )
        
        let activities = try await sportUseCase.fetchAllAcitivities()
        
        #expect(activities.first?.name == "Test1")
        #expect(activities.last?.name == "Test6")
        #expect(activities.count == 5)
    }
    
    @Test func deleteSportActivity() async throws {
        
        let activities = [
            SportActivity(id: "", name:"Test1", location: nil, duration: 101, isLocallyStored: true),
            SportActivity(id: "", name:"Test2", location: nil, duration: 102, isLocallyStored: true),
            SportActivity(id: "", name:"Test4", location: nil, duration: 104, isLocallyStored: true),
            SportActivity(id: "", name:"Test5", location: nil, duration: 105, isLocallyStored: true),
            SportActivity(id: "", name:"Test6", location: nil, duration: 106, isLocallyStored: true)
        ]
        
        let localStorageMock = DatabaseMock(fetchedActivities: activities)
        
        let state = ApplicationState(sportActivities: activities)
        
        let deleteUseCase = DeleteSportActivityUseCase(
            localStorage: localStorageMock,
            remoteStorage: DatabaseMock(fetchedActivities: []),
            state: state
        )
        
        try await deleteUseCase.deleteSportActivities(indices: IndexSet([0,3]))
        
        #expect(localStorageMock.fetchedActivities.first?.name == "Test2")
        #expect(localStorageMock.fetchedActivities.count == 3)
    }

}
