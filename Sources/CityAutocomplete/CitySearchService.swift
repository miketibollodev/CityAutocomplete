//
//  CitySearchService.swift
//  CityAutocomplete
//
//  Created by Michael Tibollo on 2026-03-28.
//

import Foundation
import FoundationModels

/// An actor that provides on-device city name autocomplete powered by Apple Intelligence.
///
/// Usage:
/// ```swift
/// let service = CitySearchService()
/// let results = try await service.search("Aus")
/// // → [Location(name: "Austin", countryCode: "US", ...),
/// //    Location(name: "Auckland", countryCode: "NZ", ...)]
/// ```
public actor CitySearchService {
    
    private let model: SystemLanguageModel
    
    private let limit: Int
    
    private var session: LanguageModelSession?
    
    private var systemInstructions: String {
        """
        You are a city autocomplete engine. When given a partial or complete city name query, \
        return exactly \(limit) matching cities as structured data. 

        Ranking rules (apply in order):
        1. Prioritize cities whose names begin with the query string over those that merely contain it.
        2. Among matches, rank by global population and relevance — major world cities first.
        3. For duplicate city names across countries, prefer the most internationally recognised one.
        4. If fewer than \(limit) cities match, return only the cities that genuinely match.
        5. If nothing matches, return an empty array.

        Always include accurate latitude and longitude in decimal degrees.
        """
    }
        
    public init(limit: Int = 5) {
        self.model = SystemLanguageModel.default
        self.limit = limit
    }
    
    /// Returns `true` if Apple Intelligence is available and ready on this device.
    ///
    /// Call this to gate your UI before presenting the search field.
    public var isAvailable: Bool {
        if case .available = model.availability { return true }
        return false
    }
    
    /// Throws a descriptive `CitySearchError` if Apple Intelligence is not ready.
    /// Called internally before every search.
    private func assertAvailable() throws {
        switch model.availability {
        case .available:
            return
        case .unavailable(.deviceNotEligible):
            throw CitySearchError.deviceNotEligible
        case .unavailable(.appleIntelligenceNotEnabled):
            throw CitySearchError.appleIntelligenceNotEnabled
        case .unavailable(.modelNotReady):
            throw CitySearchError.modelNotReady
        case .unavailable(let other):
            throw CitySearchError.unavailable(String(describing: other))
        }
    }
    
    /// Returns up to `limit` city suggestions matching the given query string.
    ///
    /// - Parameter query: A partial or full city name typed by the user.
    /// - Returns: An array of `Location` values ranked by relevance and population.
    /// - Throws: `CitySearchError` if Apple Intelligence is unavailable,
    ///           or a `LanguageModelSession` error if generation fails.
    public func search(_ query: String) async throws -> [Location] {
        try assertAvailable()

        // Reuse the session across calls so the model retains instruction context.
        if session == nil {
            session = LanguageModelSession(instructions: systemInstructions)
        }

        let prompt = "Find cities matching: \"\(query)\""

        let response = try await session!.respond(
            to: prompt,
            generating: [Location].self
        )

        return response.content
    }
    
    /// Resets the underlying model session. Call this if you want to start fresh,
    /// e.g. when the user clears the search field entirely.
    public func reset() {
        session = nil
    }
}
