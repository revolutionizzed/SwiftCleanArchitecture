//
//  ListSportActivityView.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import SwiftUI

struct ListSportActivityView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var router: Router
    @State private var isItemDetailAlertShown: Bool = false
    @State private var isDeleteAlertShown: Bool = false
    @State private var indexForDeletition: Int = 0

    @StateObject private var model: ListSportActivityPresenter.ViewModel
    let presenter: ListSportActivityPresenter

    init(presenter: ListSportActivityPresenter) {
        self.presenter = presenter
        _model = StateObject(wrappedValue: presenter.model)
    }

    var body: some View {
        TabView {
            content()
        }
        .toolbar {
            ToolbarItem {
                createSportActivityButton()
            }
        }
        .alert(isPresented: $isItemDetailAlertShown) {
            Alert(title: Text(Strings.SportActivity.List.itemNotImplemented))
        }
        .alert(isPresented: $isDeleteAlertShown) {
            Alert(
                title: Text(Strings.SportActivity.List.deleteTitle),
                message: Text(Strings.SportActivity.List.deleteMessage),
                primaryButton: .destructive(Text("Delete")) {
                    presenter.deleteItems(indices: IndexSet(integer: indexForDeletition))
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear(perform: presenter.onAppear)
    }

    @ViewBuilder
    private func content() -> some View {
        if model.isLoading {
            loadingSpinner()
        } else {
            acitivitiesList(sportAcitivities: model.allSportActivities)
                .tabItem {
                    Label("All", systemImage: "house")
                }

            acitivitiesList(sportAcitivities: model.localSportActivities)
                .tabItem {
                    Label("Internal", systemImage: "internaldrive")
                }

            acitivitiesList(sportAcitivities: model.remoteSportActivities)
                .tabItem {
                    Label("Remote", systemImage: "network")
                }
        }
    }

    private func loadingSpinner() -> some View {
        ProgressView(Strings.SportActivity.List.loading)
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }

    private func createSportActivityButton() -> some View {
        Button(action: {
            router.navigateTo(Router.Route.CreateSportActivity)
        }, label: {
            Label("Create", systemImage: "plus.circle")
        })
    }

    @ViewBuilder
    private func acitivitiesList(sportAcitivities: [SportActivity]) -> some View {
        if sportAcitivities.isEmpty {
            emptyStateView()
        } else {
            if horizontalSizeClass == .compact {
                listCells(sportAcitivities: sportAcitivities)
            } else {
                gridCells(sportAcitivities: sportAcitivities)
            }
        }
    }
    
    @ViewBuilder
    private func gridCells(sportAcitivities: [SportActivity]) -> some View {
        let columns: [GridItem] = .init(repeating: .init(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(sportAcitivities.enumerated()), id: \.element.id) { index, activity in
                    createCells(sportAcitivity: activity, index: index)
                }
            }
        }
        .padding()
    }
    
    private func listCells(sportAcitivities: [SportActivity]) -> some View {
        List {
            ForEach(Array(sportAcitivities.enumerated()), id: \.element.id) { index, activity in
                createCells(sportAcitivity: activity, index: index)
            }
            .onDelete(perform: presenter.deleteItems)
        }
        .listStyle(.plain)
    }
    
    private func createCells(sportAcitivity: SportActivity, index: Int) -> some View {
        SportActivityCellView(
            title: sportAcitivity.name,
            durationFormatted: sportAcitivity.durationFormatted,
            placeName: sportAcitivity.placeName,
            isLocal: sportAcitivity.isLocallyStored,
            action: {
                // This screen is not implemented but it will call something like:
                // router.navigateTo(Router.Route.SportActivityDetailView)
                isItemDetailAlertShown = true
            },
            deleteAction:  {
                isDeleteAlertShown = true
                indexForDeletition = index
            }
        )
    }

    private func emptyStateView() -> some View {
        VStack(spacing: 20) {
            Text(Strings.SportActivity.List.noActivityTitle)
                .font(.title)
            Text(Strings.SportActivity.List.noActivityDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300, alignment: .center)

            PrimaryButton(
                title: Strings.SportActivity.List.createActivity,
                action: {
                    router.navigateTo(Router.Route.CreateSportActivity)
                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    let model = ListSportActivityPresenter.ViewModel(
        sportActivities: [
            SportActivity(
                id: "",
                name: "Activity 1",
                location: SportActivityLocation(name: "Prague", longitude: 0.0, latitude: 0.1),
                duration: TimeInterval(200), isLocallyStored: false
            ),
            SportActivity(
                id: "",
                name: "Activity 2",
                location: nil,
                duration: TimeInterval(200),
                isLocallyStored: true
            )
        ],
        isLoading: false,
        errorMessage: nil
    )

    ListSportActivityView(
        presenter: ListSportActivityPresenter(model: model)
    )
}

#Preview {
    let emptyModel = ListSportActivityPresenter.ViewModel()
    ListSportActivityView(
        presenter: ListSportActivityPresenter(model: emptyModel)
    )
}
