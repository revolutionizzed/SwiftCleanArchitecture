//
//  CreateSportAcitivityView.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import MapKit
import SwiftUI

struct CreateSportAcitivityView: View {
    @EnvironmentObject var router: Router
    @StateObject private var model: CreateSportAcitivityPresenter.ViewModel
    let presenter: CreateSportAcitivityPresenter

    init(presenter: CreateSportAcitivityPresenter) {
        _model = StateObject(wrappedValue: presenter.model)
        self.presenter = presenter
    }

    var body: some View {
        VStack(alignment: .leading) {
            titleText()
            VStack {
                nameTextField()
                
                placeTextField()
                
                durationPicker()
                
                localStorageToggle()
                
            }.padding(.horizontal)
            
            saveButton()
        }
        .frame(maxWidth: 400)
        .padding()
    }

    private func titleText() -> some View {
        Text(Strings.SportActivity.Create.createNew)
            .font(.headline)
    }

    private func nameTextField() -> some View {
        VStack(alignment: .leading) {
            Text(model.nameErrorMessage)
                .foregroundColor(.red)
            TextField(Strings.SportActivity.Create.name, text: $model.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: model.name) {
                    presenter.validateInput()
                }
        }
    }

    private func placeTextField() -> some View {
        TextField(Strings.SportActivity.Create.place, text: $model.searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .overlay {
                placeSuggestionButton()
            }
    }

    @ViewBuilder
    private func placeSuggestionButton() -> some View {
        if let result = presenter.model.searchResult,
           result != presenter.model.searchQuery
        {
            Button(
                action: {
                    model.searchQuery = result
                },
                label: {
                    Text(result)
                }
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func durationPicker() -> some View {
        DatePicker(
            Strings.SportActivity.Create.duration,
            selection: $model.date, displayedComponents: .hourAndMinute
        )
    }
    
    private func localStorageToggle() -> some View {
        Toggle(isOn: $model.isLocallyStored) {
            Text(Strings.SportActivity.Create.storeLocally)
        }
        .toggleStyle(SwitchToggleStyle())
    }
    
    private func saveButton() -> some View {
        PrimaryButton(
            title: Strings.SportActivity.Create.save,
            action: {
                if presenter.validateInput() {
                    presenter.savePressed()
                    router.navigateBack()
                }
            }
        )
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    let model = CreateSportAcitivityPresenter.ViewModel(
        searchQuery: "Search", searchResult: "Result city"
    )

    CreateSportAcitivityView(
        presenter: CreateSportAcitivityPresenter(model: model)
    )
}
