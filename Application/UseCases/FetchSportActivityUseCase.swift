//
//  FetchSportActivityUseCase.swift
//
//  Created by David Bocko on 21.02.2025.
//

import Foundation

public class FetchSportActivityUseCase {
    private let localStorage:  DatabaseStorable
    private let remoteStorage: DatabaseStorable
    
    public init (
        localStorage: DatabaseStorable,
        remoteStorage: DatabaseStorable
    ) {
        self.localStorage = localStorage
        self.remoteStorage = remoteStorage
    }
    
    public func fetchAllAcitivities() async throws -> [SportActivity] {
        do {
            let localActivities = try await localStorage.fetchAllSportActivities()
            let remoteActivities = try await remoteStorage.fetchAllSportActivities()
            let allActivities = localActivities + remoteActivities
            return allActivities.sorted { $0.name < $1.name }
        } catch {
            throw StorageErrors.failedToRetrieve
        }
    }
}
