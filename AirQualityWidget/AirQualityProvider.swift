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
        completion(loadEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<AirQualityEntry>) -> Void
    ) {
        let entry = loadEntry()

        let nextUpdate =
            Calendar.current.date(
                byAdding: .minute,
                value: 30,
                to: Date()
            ) ?? Date().addingTimeInterval(1800)

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdate)
        )

        completion(timeline)
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
