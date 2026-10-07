//
//  MetricCard.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import SwiftUI

struct MetricCard: View {

    let title: String
    let value: String
    let unit: String

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 3
        ) {

            Text(title)
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .white.opacity(0.6)
                )

            HStack(
                alignment: .firstTextBaseline,
                spacing: 2
            ) {

                Text(value)
                    .font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundStyle(.white)

                Text(unit)
                    .font(
                        .system(
                            size: 9,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(0.4)
                    )
            }
        }

        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )

        .padding(10)

        .background(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
            .fill(
                Color.white.opacity(0.06)
            )
        )

        .overlay(
            RoundedRectangle(
                cornerRadius: 12,
                style: .continuous
            )
            .stroke(
                Color.white.opacity(0.08),
                lineWidth: 1
            )
        )
    }
}
