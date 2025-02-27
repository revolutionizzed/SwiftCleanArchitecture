//
//  DomainProxy.swift
//
//  Created by David Bocko on 22.02.2025.
//

import Foundation
import Combine

public class DomainProxy: ObservableObject
{
    public typealias StatePublisher = CurrentValueSubject<ApplicationState, Never>
    
    public let statePublisher = StatePublisher(ApplicationState(sportActivities: []))
    
    let localStorage: DatabaseStorable
    let remoteStorage: DatabaseStorable
    
    public init(
        localStorage: DatabaseStorable,
        remoteStorage: DatabaseStorable
    ) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }

    public func fetchAllAcitivitiesRequest() async throws {
        let useCase = FetchSportActivityUseCase(
            localStorage: localStorage ,
            remoteStorage: remoteStorage
        )
        let activities = try await useCase.fetchAllAcitivities()
        statePublisher.send(ApplicationState(sportActivities: activities))
    }
    
    public func storeRequest(sportActivity: SportActivity) async throws {
        let useCase = StoreSportActivityUseCase(localStorage: localStorage, remoteStorage: remoteStorage)
        try await useCase.store( sportActivity: sportActivity)
    }
    
    public func deleteRequest(indices: IndexSet) async throws {
        let useCase = DeleteSportActivityUseCase(
            localStorage: localStorage,
            remoteStorage: remoteStorage,
            state: statePublisher.value
        )
        try await useCase.deleteSportActivities(indices: indices)
        try await fetchAllAcitivitiesRequest( )
    }
}
