//
//  RemoteDatabaseAccessor.swift
//  SportStorageApp
//
//  Created by David Bocko on 21.02.2025.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class RemoteDatabaseAccessor: DatabaseStorable {
    let database: DatabaseReference
    let appInstallID: String
    init() {
        FirebaseApp.configure()
        database = Database.database().reference()
        appInstallID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }

    func store(sportActivity: SportActivity) async throws {
        do {
            try await database
                .child("users")
                .child(appInstallID)
                .child("sportActivities")
                .child(sportActivity.id)
                .setValue(sportActivity.toDictionary())
        } catch {
            throw StorageErrors.failedToStore
        }
    }

    func fetchAllSportActivities() async throws -> [SportActivity] {
        do {
            let snapshot = try await database
                .child("users")
                .child(appInstallID)
                .child("sportActivities")
                .getData()
            
            if let value = snapshot.value as? [String: [String: Any]] {
                let activities = try value.compactMap { key, value -> SportActivity? in
                    return try JSONDecoder().decode(SportActivity.self, from: JSONSerialization.data(withJSONObject: value))
                }
                return activities
            }
        } catch {
            throw StorageErrors.failedToRetrieve
        }
        return []
    }
    
    func delete(sportActivity: SportActivity) async throws {
        do {
            try await database
                .child("users")
                .child(appInstallID)
                .child("sportActivities")
                .child(sportActivity.id)
                .removeValue()
        } catch {
            throw StorageErrors.failedToDelete
        }
    }
}

private extension SportActivity {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "isLocallyStored": isLocallyStored
        ]

        if let location = location {
            dict["location"] = location.toDictionary()
        }

        if let duration = duration {
            dict["duration"] = duration
        }

        return dict
    }
}

private extension SportActivityLocation {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let name = name {
            dict["name"] = name
        }
        if let latitude = latitude {
            dict["latitude"] = latitude
        }
        if let longitude = longitude {
            dict["longitude"] = longitude
        }
        return dict
    }
}
