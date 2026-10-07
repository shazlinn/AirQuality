//
//  AirQualityWidget.swift
//  AirQualityWidget
//
//  Created by Shazlin Othman on 08/10/2026.
//

import WidgetKit
import SwiftUI

struct AirQualityWidget: Widget {

    let kind: String = "AirQualityWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in

            AirQualityWidgetEntryView(
                entry: entry
            )
        }

        .configurationDisplayName(
            "Air Quality"
        )

        .description(
            "Shows the latest air quality near you."
        )

        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}
