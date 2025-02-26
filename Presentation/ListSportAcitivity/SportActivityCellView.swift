//
//  SportActivityCellView.swift
//  SportStorageApp
//
//  Created by David Bocko on 23.02.2025.
//

import SwiftUI

struct SportActivityCellView: View {
    var title: String
    var durationFormatted: String
    var placeName: String
    var isLocal: Bool

    var action: (() -> Void)?
    var deleteAction: (() -> Void)?

    var body: some View {
        Button(
            action: {
                action?()
            },
            label: {
                content()
            }
        )
        .foregroundColor(.black)
    }

    private func content() -> some View {
        HStack {
            titleAndPlaceStack()

            Spacer()

            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.primary)

                    Text(durationFormatted)
                        .foregroundColor(.primary)
                        .font(.subheadline)
                }
                if isLocal {
                    localTextAndIcon()
                } else {
                    remoteTextAndIcon()
                }
            }
            if deleteAction != nil {
                deleteButton()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            gradientView()
        )
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 2, y: 2)
    }

    private func remoteTextAndIcon() -> some View {
        HStack {
            Image(systemName: "network")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .foregroundColor(.primary)

            Text("Remote")
                .foregroundColor(.primary)
                .font(.subheadline)
        }
    }

    private func localTextAndIcon() -> some View {
        HStack {
            Image(systemName: "internaldrive")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .foregroundColor(.primary)

            Text("Internal")
                .foregroundColor(.primary)
                .font(.subheadline)
        }
    }

    @ViewBuilder
    private func gradientView() -> some View {
        if isLocal {
            gradient(color: .blue.opacity(0.2))
        } else {
            gradient(color: .red.opacity(0.2))
        }
    }

    private func gradient(color: Color) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [color, .clear]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private func titleAndPlaceStack() -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.primary)
                .font(.headline)
            Text(placeName)
                .foregroundColor(.primary)
                .font(.subheadline)
        }
    }

    private func deleteButton() -> some View {
        Button(action: {
            deleteAction?()
        }) {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 12, height: 12, alignment: .top)
                .foregroundColor(.primary)
                .padding()
        }
    }
}

#Preview {
    SportActivityCellView(
        title: "Sport activity name",
        durationFormatted: "14:55 min",
        placeName: "Prague",
        isLocal: false,
        deleteAction: {}
    )
}
