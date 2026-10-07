//
//  AQIStyle.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import SwiftUI

struct AQIStyle {

    static func accentColor(for aqi: Double) -> Color {

        switch aqi {

        case 0...50:
            return Color(
                red: 0.40,
                green: 0.60,
                blue: 0.98
            )

        case 51...100:
            return Color(
                red: 0.52,
                green: 0.40,
                blue: 0.98
            )

        case 101...150:
            return Color(
                red: 0.70,
                green: 0.40,
                blue: 0.95
            )

        case 151...200:
            return Color(
                red: 0.85,
                green: 0.35,
                blue: 0.75
            )

        case 201...300:
            return Color(
                red: 0.65,
                green: 0.20,
                blue: 0.80
            )

        default:
            return Color(
                red: 0.45,
                green: 0.15,
                blue: 0.55
            )
        }
    }

    static func label(for aqi: Double) -> String {

        switch aqi {

        case 0...50:
            return "Good"

        case 51...100:
            return "Moderate"

        case 101...150:
            return "Sensitive"

        case 151...200:
            return "Unhealthy"

        case 201...300:
            return "Very Unhealthy"

        default:
            return "Hazardous"
        }
    }

    static func formatted(_ value: Double?) -> String {

        guard let value else {
            return "--"
        }

        return String(
            format: "%.1f",
            value
        )
    }
}
