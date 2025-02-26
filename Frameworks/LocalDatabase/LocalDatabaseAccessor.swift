//
//  LocalDatabaseAccessor.swift
//  SportStorageApp
//
//  Created by David Bocko on 21.02.2025.
//

import CoreData

struct LocalDatabaseAccessor: DatabaseStorable {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SportStorageApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    func store(sportActivity: SportActivity) async throws {
        sportActivity.setContext(context: container.viewContext)
        do {
            try save()
        } catch {
            throw StorageErrors.failedToStore
        }
    }

    func fetchAllSportActivities() async throws -> [SportActivity] {
        let fetchRequest: NSFetchRequest<SportActivityDB> = SportActivityDB.fetchRequest()

        do {
            let items = try container.viewContext.fetch(fetchRequest)
            return items.map { $0.sportActivity }
        } catch {
            throw StorageErrors.failedToRetrieve
        }
    }

    func delete(sportActivity: SportActivity) async throws {
        let context = container.viewContext
        if let objectID = convertStringToManagedObjectID(sportActivity.id, context: context),
           let activityDB = try context.existingObject(with: objectID) as? SportActivityDB
        {
            context.delete(activityDB)
            do {
                try save()
            } catch {
                throw StorageErrors.failedToDelete
            }
        } else {
            throw StorageErrors.failedToDelete
        }
    }

    private func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

    func convertStringToManagedObjectID(_ objectIDString: String, context: NSManagedObjectContext) -> NSManagedObjectID? {
        guard let url = URL(string: objectIDString) else {
            return nil
        }
        guard let persistentStoreCoordinator = context.persistentStoreCoordinator else {
            return nil
        }
        return persistentStoreCoordinator.managedObjectID(forURIRepresentation: url)
    }
}

// Mappings from Entity to DB and vice versa
extension SportActivityDB {
    var sportActivity: SportActivity {
        let location = SportActivityLocation(
            name: self.location?.name ?? "",
            longitude: self.location?.longitude,
            latitude: self.location?.latitude
        )
        return SportActivity(
            id: objectID.uriRepresentation().absoluteString,
            name: name ?? "",
            location: location,
            duration: duration,
            isLocallyStored: isLocallyStored
        )
    }
}

extension SportActivity {
    func setContext(context: NSManagedObjectContext) {
        let activityDB = SportActivityDB(context: context)
        activityDB.id = id
        activityDB.name = name
        activityDB.isLocallyStored = isLocallyStored
        if let duration = duration {
            activityDB.duration = duration
        }
        if let location = location {
            let locationDB = SportActivityLocationDB(context: context)
            if let name = location.name {
                locationDB.name = name
            }
            if let latitude = location.latitude {
                locationDB.latitude = latitude
            }
            if let longitude = location.longitude {
                locationDB.longitude = longitude
            }
            activityDB.location = locationDB
        }
    }
}
