//
//  AirQualityProvider.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import WidgetKit
import Foundation

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> AirQualityEntry {
        AirQualityEntry(
            date: Date(),
            aqi: 42,
            pm25: 12.4,
            pm10: 20.1,
            lastUpdated: Date(),
            locationName: "Kuala Lumpur"
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (AirQualityEntry) -> Void
    ) {
        completion(context.isPreview ? placeholder(in: context) : loadEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<AirQualityEntry>) -> Void
    ) {
        Task {
            let defaults = UserDefaults(suiteName: "group.com.shazlin.AirQuality")

            // The app saves coordinates once; subsequent refreshes run in the extension.
            if let latitude = defaults?.object(forKey: "latitude") as? Double,
               let longitude = defaults?.object(forKey: "longitude") as? Double {
                do {
                    let result = try await AirQualityService().fetchAirQuality(
                        latitude: latitude,
                        longitude: longitude
                    )
                    // Do not overwrite a newer location selected while the request ran.
                    if defaults?.object(forKey: "latitude") as? Double == latitude,
                       defaults?.object(forKey: "longitude") as? Double == longitude {
                        defaults?.set(result.us_aqi, forKey: "usAQI")
                        defaults?.set(result.pm2_5, forKey: "pm25")
                        defaults?.set(result.pm10, forKey: "pm10")
                        defaults?.set(Date(), forKey: "lastUpdated")
                    }
                } catch {
                    // Keep the last successful readings and their original timestamp offline.
                }
            }

            completion(Timeline(
                entries: [loadEntry()],
                policy: .after(Date().addingTimeInterval(30 * 60))
            ))
        }
    }

    private func loadEntry() -> AirQualityEntry {

        let defaults = UserDefaults(
            suiteName: "group.com.shazlin.AirQuality"
        )

        let aqi =
            defaults?.double(forKey: "usAQI") ?? 0

        let pm25 =
            defaults?.object(forKey: "pm25") as? Double

        let pm10 =
            defaults?.object(forKey: "pm10") as? Double

        let lastUpdated =
            defaults?.object(forKey: "lastUpdated") as? Date

        let locationName =
            defaults?.string(forKey: "locationName")
            ?? "Current Location"

        return AirQualityEntry(
            date: Date(),
            aqi: aqi,
            pm25: pm25,
            pm10: pm10,
            lastUpdated: lastUpdated,
            locationName: locationName
        )
    }
}
