//
//  CitySearchError.swift
//  CityAutocomplete
//
//  Created by Michael Tibollo on 2026-03-28.
//

import Foundation

public enum CitySearchError: LocalizedError {
    case deviceNotEligible
    case appleIntelligenceNotEnabled
    case modelNotReady
    case unavailable(String)

    public var errorDescription: String? {
        switch self {
        case .deviceNotEligible:
            return "This device does not support Apple Intelligence."
        case .appleIntelligenceNotEnabled:
            return "Apple Intelligence is not enabled. Please enable it in Settings."
        case .modelNotReady:
            return "The language model is not ready yet. Please try again shortly."
        case .unavailable(let reason):
            return "Apple Intelligence is unavailable: \(reason)"
        }
    }
}
