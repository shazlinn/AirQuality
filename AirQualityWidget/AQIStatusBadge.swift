//
//  AQIStatusBadge.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import SwiftUI

struct AQIStatusBadge: View {

    let text: String
    let color: Color

    var font: Font = .caption2
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 3

    var body: some View {

        Text(text)
            .font(font)
            .fontWeight(.bold)

            .padding(
                .horizontal,
                horizontalPadding
            )

            .padding(
                .vertical,
                verticalPadding
            )

            .background(
                Capsule()
                    .fill(
                        color.opacity(0.25)
                    )
            )

            .overlay(
                Capsule()
                    .stroke(
                        color.opacity(0.4),
                        lineWidth: 1
                    )
            )

            .foregroundStyle(color)
    }
}
