//
//  Location.swift
//  CityAutocomplete
//
//  Created by Michael Tibollo on 2026-03-28.
//

import CoreLocation
import Foundation
import FoundationModels

/// A structured representation of a city result returned by CitySearchService.
@Generable(description: "Structure defining a city")
public struct Location: Hashable, Codable, Sendable {
        
    /// City name (example: "London")
    @Guide(description: "The city or town name")
    public let name: String
    
    /// ISO-2 country code (example: "US")
    @Guide(description: "ISO-2 format two-letter country code")
    public let countryCode: String
    
    /// Country name (example: "Canada")
    @Guide(description: "Full country name in English")
    public let country: String
    
    /// The state, province, or administrative region (example: "Texas")
    @Guide(description: "State, province, or primary administrative region")
    public let adminRegion: String
    
    /// Latitude in decimal degrees (example: 30.2672)
    @Guide(description: "Latitude in decimal degrees, e.g. 30.2672")
    public let lat: Double
    
    /// Longitude in decimal degrees (example: -97.7431)
    @Guide(description: "Longitude in decimal degrees, e.g. -97.7431")
    public let lon: Double
    
    public init(
        name: String,
        countryCode: String,
        country: String,
        adminRegion: String,
        lat: Double,
        lon: Double
    ) {
        self.name = name
        self.countryCode = countryCode
        self.country = country
        self.adminRegion = adminRegion
        self.lat = lat
        self.lon = lon
    }
}

extension Location {
    
    /// Convenience accessor returning a CoreLocation coordinate.
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

extension Location: Identifiable {
    
    public var id: String { "\(name)-\(countryCode)-\(lat)-\(lon)" }
}
