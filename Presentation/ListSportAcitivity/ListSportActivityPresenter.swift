//
//  ListSportActivityPresenter.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import Combine
import Foundation

class ListSportActivityPresenter {
    class ViewModel: ObservableObject {
        @Published var allSportActivities: [SportActivity] = []
        @Published var remoteSportActivities: [SportActivity] = []
        @Published var localSportActivities: [SportActivity] = []
        @Published var isLoading: Bool = false
        @Published var errorMessage: String? = nil
        
        public init() {}
        
        // Used by Previews for injecting values
        public init(sportActivities: [SportActivity], isLoading: Bool, errorMessage: String? = nil) {
            self.allSportActivities = sportActivities
            self.remoteSportActivities = sportActivities.filter { $0.isLocallyStored == false }
            self.localSportActivities = sportActivities.filter { $0.isLocallyStored == true }
            
            self.isLoading = isLoading
            self.errorMessage = errorMessage
        }
    }

    private(set) var model: ViewModel = .init()
    
    private var cancellable: AnyCancellable?
    private var domainProxy: DomainProxy?
    
    init(domainProxy: DomainProxy?) {
        self.domainProxy = domainProxy
        model.isLoading = true
        self.cancellable = domainProxy?.statePublisher
            .receive(on: DispatchQueue.main)
            .handleEvents( receiveOutput: { [weak self] state in
                self?.updateUI(state: state)
            })
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] state in
                self?.setIsLoading(state: state)
            }
    }
    
    func onAppear() {
        fetchItems()
    }
    
    public func deleteItems(indices: IndexSet) {
        Task {
            do {
                try await domainProxy?.deleteRequest(indices: indices)
            } catch {
                model.errorMessage = Strings.SportActivity.List.unableToDelete
            }
        }
    }
    
    private func fetchItems() {
        Task {
            do {
                try await domainProxy?.fetchAllAcitivitiesRequest()
            } catch {
                model.errorMessage = Strings.SportActivity.List.unableToFetch
            }
        }
    }
    
    private func updateUI(state: ApplicationState) {
        if let activities = state.sportActivities {
            self.model.allSportActivities = activities
            self.model.remoteSportActivities = activities.filter { $0.isLocallyStored == false }
            self.model.localSportActivities = activities.filter { $0.isLocallyStored == true }
        }
    }
    
    private func setIsLoading(state: ApplicationState) {
        self.model.isLoading = state.sportActivities == nil
    }
}

extension SportActivity {
    var durationFormatted: String {
        guard let duration else {
            return ""
        }
        return duration.toFormattedString()
    }
    
    var placeName: String {
        guard let name = location?.name else {
            return ""
        }
        return name
    }
}

// Used in Xcode previews
extension ListSportActivityPresenter {
    convenience init(model: ViewModel) {
        self.init(domainProxy: nil)
        self.model = model
    }
}
