//
//  RouterView.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import SwiftUI
import SwiftCleanApplication

struct RouterView<Content: View>: View {
    @StateObject var router: Router = Router()
    @EnvironmentObject var domain: DomainProxy
    
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: Router.Route.self) { route in
                    router.view(for: route, domain: domain)
                }
        }
        .environmentObject(router)
    }
}
