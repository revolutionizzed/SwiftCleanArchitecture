//
//  Router.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//
import SwiftUI
import SwiftCleanApplication

@MainActor
class Router: ObservableObject {
    enum Route: Hashable {
        case ListSportActivityView
        case CreateSportActivity
    }
    
    @Published @MainActor var path: NavigationPath
    
    init() {
        self.path = NavigationPath()
    }
    
    // Builds the views
    @ViewBuilder func view(for route: Route, domain: DomainProxy) -> some View {
        switch route {
        case .ListSportActivityView:
            ListSportActivityView(presenter: ListSportActivityPresenter(domainProxy: domain))
        case .CreateSportActivity:
            CreateSportAcitivityView(presenter: CreateSportAcitivityPresenter(domainProxy: domain))
        }
    }
    
    // Used by views to navigate to another view
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    // Used to go back to the previous screen
    func navigateBack() {
        path.removeLast()
    }
    
    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}
