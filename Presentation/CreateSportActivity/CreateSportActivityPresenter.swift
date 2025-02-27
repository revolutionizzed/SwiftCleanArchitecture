//
//  CreateSportActivityPresenter.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import Combine
import Foundation
import MapKit
import SwiftCleanApplication

class CreateSportAcitivityPresenter {
    class ViewModel: ObservableObject {
        @Published var searchQuery = ""
        @Published var searchResult: String? = nil
        @Published var date: Date = .zeroTime
        @Published var name: String = ""
        @Published var nameErrorMessage: String = ""
        @Published var isLocallyStored: Bool = false
        
        public var duration: TimeInterval {
            date.timeIntervalSince(startDate)
        }
    
        private let startDate = Date.zeroTime
        
        public init() {}
        
        // Used by Previews for injecting values 
        public init(searchQuery: String, searchResult: String?) {
            self.searchQuery = searchQuery
            self.searchResult = searchResult
        }
    }

    public var model: ViewModel = .init()
    
    private var domainProxy: DomainProxy?
    private var location: MKMapItem?
    private var cancellables = Set<AnyCancellable>()
    
    init(domainProxy: DomainProxy?) {
        self.domainProxy = domainProxy
        model.$searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    @discardableResult
    public func validateInput() -> Bool {
        if model.name.count > 0 {
            model.nameErrorMessage = ""
            return true
        } else {
            model.nameErrorMessage = Strings.SportActivity.Create.pleaseFillName
            return false
        }
    }
    
    public func savePressed() {
        Task {
            let sportActivity: SportActivity = .init(
                id: UUID().uuidString,
                name: model.name,
                location: mapItemToLocation(mapItem: location),
                duration: model.duration,
                isLocallyStored: model.isLocallyStored
            )
                
            try await domainProxy?.storeRequest(sportActivity: sportActivity)
            try await domainProxy?.fetchAllAcitivitiesRequest()
        }
    }
    
    // If the application will use the MapKit more intensively,
    // this needs to be moved to UseCases and properly tested.
    private func performSearch(query: String) {
        guard query.count > 0 else {
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }

            self.model.searchResult = response.mapItems.first?.name
            self.location = response.mapItems.first
        }
    }
                
    private func mapItemToLocation(mapItem: MKMapItem?) -> SportActivityLocation {
        let coordinate = mapItem?.placemark.coordinate
        return SportActivityLocation(name: mapItem?.name, longitude: coordinate?.longitude, latitude: coordinate?.latitude)
    }
}

// Used in Xcode previews
extension CreateSportAcitivityPresenter {
    convenience init(model: ViewModel) {
        self.init(domainProxy: nil)
        self.model = model
    }
}
