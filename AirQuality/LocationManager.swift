//
//  LocationManager.swift
//  MyApp
//
//  Created by Shazlin Othman on 08/10/2026.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationName: String = "Current Location"

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorized {
            manager.requestLocation()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }

        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude

        Task {
            await updateLocationName(from: location)
        }
    }

    private func updateLocationName(from location: CLLocation) async {
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return
        }

        do {
            let mapItems = try await request.mapItems

            guard let mapItem = mapItems.first else {
                return
            }

            let name =
                mapItem.addressRepresentations?.cityName ??
                mapItem.name ??
                "Current Location"

            await MainActor.run {
                self.locationName = name
            }

        } catch {
            print("Reverse geocoding error:", error.localizedDescription)
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error:", error.localizedDescription)
    }
}
