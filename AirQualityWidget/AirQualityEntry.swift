//
//  AirQualityEntry.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import WidgetKit
import Foundation

struct AirQualityEntry: TimelineEntry {
    let date: Date
    let aqi: Double
    let pm25: Double?
    let pm10: Double?
    let lastUpdated: Date?
    let locationName: String
}
