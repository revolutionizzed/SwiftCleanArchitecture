//
//  StoreSportActivityUseCase.swift
//
//  Created by David Bocko on 21.02.2025.
//

import Foundation

public class StoreSportActivityUseCase {
    private let localStorage:  DatabaseStorable
    private let remoteStorage: DatabaseStorable
    
    public init (
        localStorage: DatabaseStorable,
        remoteStorage: DatabaseStorable
    ) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }
    
    public func store(
        sportActivity: SportActivity
    ) async throws
    {
        do {
            if sportActivity.isLocallyStored {
                try await localStorage.store(sportActivity: sportActivity)
            } else {
                try await remoteStorage.store(sportActivity: sportActivity)
            }
        } catch {
            throw StorageErrors.failedToStore
        }
    }
}
