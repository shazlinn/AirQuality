//
//  AirQualityService.swift
//  AirQuality
//
//  Created by Shazlin Othman on 08/10/2026.
//

import Foundation

struct AirQualityResponse: Codable {
    let current: CurrentAirQuality
}

struct CurrentAirQuality: Codable {
    let us_aqi: Double
    let pm2_5: Double?
    let pm10: Double?
}

class AirQualityService {

    func fetchAirQuality(
        latitude: Double,
        longitude: Double
    ) async throws -> CurrentAirQuality {

        let urlString =
        """
        https://air-quality-api.open-meteo.com/v1/air-quality?latitude=\(latitude)&longitude=\(longitude)&current=us_aqi,pm2_5,pm10
        """

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(
            AirQualityResponse.self,
            from: data
        )

        return decoded.current
    }
}
