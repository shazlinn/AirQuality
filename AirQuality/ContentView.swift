import SwiftUI
import WidgetKit

struct ContentView: View {

    @StateObject private var locationManager = LocationManager()

    @State private var airQuality: CurrentAirQuality?
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {

            Text("Air Quality")
                .font(.largeTitle)
                .bold()

            HStack(spacing: 6) {
                Image(systemName: "location.fill")

                Text(locationManager.locationName)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            if let airQuality {

                Text("\(Int(airQuality.us_aqi))")
                    .font(.system(size: 72, weight: .bold))

                Text(aqiLabel(airQuality.us_aqi))
                    .font(.title2)

                if let pm25 = airQuality.pm2_5 {
                    Text("PM2.5: \(pm25, specifier: "%.1f") µg/m³")
                }

                if let pm10 = airQuality.pm10 {
                    Text("PM10: \(pm10, specifier: "%.1f") µg/m³")
                }

            } else if isLoading {

                ProgressView("Getting air quality...")

            } else if let errorMessage {

                Text(errorMessage)
                    .foregroundStyle(.red)

            } else {

                Text("Waiting for location...")
                    .foregroundStyle(.secondary)
            }

            Button("Refresh") {
                fetchAQI()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
        .frame(width: 420, height: 400)

        .onAppear {
            locationManager.requestLocation()
        }

        .onChange(of: locationManager.latitude) {
            fetchAQI()
        }

        .onChange(of: locationManager.locationName) {
            saveLocationToWidget()
        }
    }

    private func fetchAQI() {

        guard
            let latitude = locationManager.latitude,
            let longitude = locationManager.longitude
        else {
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let service = AirQualityService()

                let result = try await service.fetchAirQuality(
                    latitude: latitude,
                    longitude: longitude
                )

                let sharedDefaults = UserDefaults(
                    suiteName: "group.com.shazlin.AirQuality"
                )

                sharedDefaults?.set(
                    result.us_aqi,
                    forKey: "usAQI"
                )

                if let pm25 = result.pm2_5 {
                    sharedDefaults?.set(
                        pm25,
                        forKey: "pm25"
                    )
                }

                if let pm10 = result.pm10 {
                    sharedDefaults?.set(
                        pm10,
                        forKey: "pm10"
                    )
                }

                sharedDefaults?.set(
                    locationManager.locationName,
                    forKey: "locationName"
                )

                sharedDefaults?.set(
                    Date(),
                    forKey: "lastUpdated"
                )

                WidgetCenter.shared.reloadTimelines(
                    ofKind: "AirQualityWidget"
                )

                await MainActor.run {
                    airQuality = result
                    isLoading = false
                }

            } catch {

                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }

    private func saveLocationToWidget() {

        let sharedDefaults = UserDefaults(
            suiteName: "group.com.shazlin.AirQuality"
        )

        sharedDefaults?.set(
            locationManager.locationName,
            forKey: "locationName"
        )

        WidgetCenter.shared.reloadTimelines(
            ofKind: "AirQualityWidget"
        )
    }

    private func aqiLabel(_ aqi: Double) -> String {

        switch aqi {

        case 0...50:
            return "Good"

        case 51...100:
            return "Moderate"

        case 101...150:
            return "Unhealthy for Sensitive Groups"

        case 151...200:
            return "Unhealthy"

        case 201...300:
            return "Very Unhealthy"

        default:
            return "Hazardous"
        }
    }
}
