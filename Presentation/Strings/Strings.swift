//
//  Strings.swift
//  SportStorageApp
//
//  Created by David Bocko on 24.02.2025.
//

import Foundation

public enum Strings {
    public enum SportActivity {
        public enum Create {
            public static let createNew = String(localized: "createNewActivity")
            public static let name = String(localized: "name")
            public static let place = String(localized: "place")
            public static let duration = String(localized: "duration")
            public static let save = String(localized: "save")
            public static let storeLocally = String(localized: "storeLocally")
            public static let pleaseFillName = String(localized: "pleaseFillName")
        }

        public enum List {
            public static let noActivityDescription = String(localized: "noActivityDescription")
            public static let createActivity = String(localized: "createActivity")
            public static let noActivityTitle = String(localized: "noActivityTitle")
            public static let itemNotImplemented = String(localized: "itemNotImplemented")
            public static let loading = String(localized: "loading")
            public static let deleteTitle = String(localized: "deleteTitle")
            public static let deleteMessage = String(localized: "deleteMessage")
            public static let unableToDelete = String(localized: "unableToDelete")
            public static let unableToFetch = String(localized: "unableToFetch")
        }
    }
}
