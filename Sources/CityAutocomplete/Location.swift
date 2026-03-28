//
//  Location.swift
//  CityAutocomplete
//
//  Created by Michael Tibollo on 2026-03-28.
//

import Foundation
import FoundationModels

/// A structured representation of a city result returned by CitySearchService.
@Generable(description: "Structure defining a city")
public struct Location: Identifiable, Equatable, Hashable, Sendable {
    
    public let id: UUID
    
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
        id: UUID = UUID(),
        name: String,
        countryCode: String,
        country: String,
        adminRegion: String,
        lat: Double,
        lon: Double
    ) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.country = country
        self.adminRegion = adminRegion
        self.lat = lat
        self.lon = lon
    }
}
