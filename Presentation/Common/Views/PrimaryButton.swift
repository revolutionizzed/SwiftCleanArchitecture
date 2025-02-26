//
//  PrimaryButton.swift
//  SportStorageApp
//
//  Created by David Bocko on 24.02.2025.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.blue)
                .cornerRadius(30)
        }
    }
}

#Preview {
    PrimaryButton(title: "Title", action: {})
}
