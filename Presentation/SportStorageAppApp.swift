//
//  SportStorageAppApp.swift
//  SportStorageApp
//
//  Created by David Bocko on 21.02.2025.
//

import SwiftUI

@main
struct SportStorageAppApp: App {

    let localDatabase: LocalDatabaseAccessor
    let remoteDatabase: RemoteDatabaseAccessor
    let domain: DomainProxy
    
    init(){
        self.localDatabase = LocalDatabaseAccessor()
        self.remoteDatabase = RemoteDatabaseAccessor()
        self.domain = DomainProxy(localStorage: localDatabase, remoteStorage: remoteDatabase)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(domain)
        }
    }
}
