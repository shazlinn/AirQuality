//
//  AirQualityWidgetView.swift
//  AirQualityWidgetExtension
//
//  Created by Shazlin Othman on 08/10/2026.
//

import SwiftUI
import WidgetKit

struct AirQualityWidgetEntryView: View {

    var entry: Provider.Entry

    @Environment(\.widgetFamily)
    private var family

    private var accentColor: Color {
        AQIStyle.accentColor(for: entry.aqi)
    }

    var body: some View {
        Group {
            if family == .systemSmall {
                smallWidgetView
            } else {
                mediumWidgetView
            }
        }
        .containerBackground(for: .widget) {
            ZStack {
                // 1. Deep charcoal / near-black native base
                Color(red: 0.05, green: 0.05, blue: 0.07)

                // 2. Soft, diffused ambient status color wash (Apple-style atmospheric glow)
                LinearGradient(
                    colors: [
                        accentColor.opacity(0.18),
                        Color.clear,
                        Color.black.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }

    // MARK: - Small Widget

    private var smallWidgetView: some View {
        VStack(alignment: .leading, spacing: 4) {
            smallHeaderView

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 6) {
                Text("\(Int(entry.aqi))")
                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(
                        color: accentColor.opacity(0.3),
                        radius: 12,
                        x: 0,
                        y: 4
                    )

                AQIStatusBadge(
                    text: AQIStyle.label(for: entry.aqi),
                    color: accentColor,
                    font: .caption2,
                    horizontalPadding: 10,
                    verticalPadding: 3
                )
            }

            Spacer(minLength: 0)

            updatedView
        }
        .padding(18)
    }

    // MARK: - Medium Widget

    private var mediumWidgetView: some View {
        HStack(alignment: .top, spacing: 16) {
            // Left Column: Main AQI focus
            VStack(alignment: .leading, spacing: 6) {
                mediumHeaderView

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 6) {
                    Text("\(Int(entry.aqi))")
                        .font(.system(size: 46, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(
                            color: accentColor.opacity(0.35),
                            radius: 14,
                            x: 0,
                            y: 4
                        )

                    AQIStatusBadge(
                        text: AQIStyle.label(for: entry.aqi),
                        color: accentColor,
                        font: .subheadline,
                        horizontalPadding: 12,
                        verticalPadding: 5
                    )
                }

                Spacer(minLength: 0)

                updatedView
            }

            Spacer(minLength: 0)

            // Right Column: Frosted, low-contrast PM cards
            VStack(spacing: 10) {
                metricCard(
                    title: "PM2.5",
                    value: AQIStyle.formatted(entry.pm25),
                    unit: "µg/m³"
                )

                metricCard(
                    title: "PM10",
                    value: AQIStyle.formatted(entry.pm10),
                    unit: "µg/m³"
                )
            }
            .frame(width: 98)
            .padding(.top, 1) // Perfectly aligns with header row
        }
        .padding(20) // Generous padding preventing edge compression
    }

    // MARK: - Headers

    private var smallHeaderView: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: "aqi.medium")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(accentColor)

                Text("AQI")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)
            }

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 8, weight: .semibold))

                Text(compactLocationText)
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.white.opacity(0.45))
        }
    }

    private var mediumHeaderView: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 6) {
                Image(systemName: "aqi.medium")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(accentColor)

                Text("Air Quality")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)

                Spacer()
            }

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 9, weight: .semibold))

                Text(entry.locationName)
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(.white.opacity(0.45))
        }
    }

    // MARK: - Subcomponents & Helpers

    private var updatedView: some View {
        Group {
            if let lastUpdated = entry.lastUpdated {
                Text("Updated \(lastUpdated, style: .time)")
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundStyle(.white.opacity(0.35)) // Quiet, non-competing timestamp
                    .lineLimit(1)
            } else {
                Text("Waiting for data")
                    .font(.system(size: 9.5, weight: .regular))
                    .foregroundStyle(.white.opacity(0.35))
                    .lineLimit(1)
            }
        }
    }

    private func metricCard(title: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.system(size: 10.5, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text(unit)
                    .font(.system(size: 8.5, weight: .regular))
                    .foregroundStyle(.white.opacity(0.3)) // Super dim unit so the number pops
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.04)) // Ultra-low opacity frosted glass panel
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.06), lineWidth: 0.5) // Faint, crisp Apple-like border
        )
    }

    private var compactLocationText: String {
        if entry.locationName == "Current Location" {
            return "Nearby"
        } else {
            return entry.locationName
        }
    }
}
