//
//  DeleteSportActivityUseCase.swift
//
//  Created by David Bocko on 25.02.2025.
//

import Foundation

public class DeleteSportActivityUseCase {
    private let localStorage: DatabaseStorable
    private let remoteStorage: DatabaseStorable
    private let state: ApplicationState
    
    public init(
        localStorage: DatabaseStorable,
        remoteStorage: DatabaseStorable,
        state: ApplicationState
    ) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
        self.state = state
    }
    
    public func deleteSportActivities(
        indices: IndexSet
    ) async throws {
        do {
            guard let sportActivities = state.sportActivities else {
                return
            }
            
            for index in indices {
                let activity = sportActivities[index]
                if activity.isLocallyStored {
                    try await localStorage.delete(sportActivity: activity)
                } else {
                    try await remoteStorage.delete(sportActivity: activity)
                }
            }
        } catch {
            throw StorageErrors.failedToDelete
        }
    }
}
