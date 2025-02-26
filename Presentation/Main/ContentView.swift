//
//  ContentView.swift
//  SportStorageApp
//
//  Created by David Bocko on 21.02.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var domain: DomainProxy

    var body: some View {
        RouterView {
            ListSportActivityView(presenter: ListSportActivityPresenter(domainProxy: domain))
        }
        
    }
}
