# CitySuggest

On-device city name autocomplete for Apple platforms, powered by Apple Intelligence.

---

## Background

Adding city autocomplete to an Apple app sounds straightforward. In practice, the available options all come with meaningful trade-offs:

- **Bundled datasets** — Libraries that ship a static list of world cities work offline and have no usage limits, but they add megabytes to your app and require you to maintain your own fuzzy search logic. Ranking results by global relevance (rather than alphabetically) is non-trivial.
- **`MKLocalSearchCompleter`** — Apple's built-in completer is designed for points of interest and routing, not for returning the top cities worldwide. It prioritises places near the user's current location, making it unreliable for apps that need globally relevant suggestions regardless of where the user is.
- **Third-party APIs** (Google Places, Mapbox, etc.) — These return excellent results but introduce per-request pricing, rate limits, a network dependency, and a privacy consideration: every keystroke is sent to an external server.

CitySuggest takes a different approach. It uses the on-device language model provided by Apple Intelligence — already present on the user's device, private, and free at the point of use — to generate ranked city suggestions from a partial query.

---

## Requirements

- iOS 26+ / macOS 26+ / visionOS 3+
- Apple Intelligence enabled on the device

---

## Installation

In Xcode, go to **File → Add Package Dependencies** and enter the repository URL:

```
https://github.com/your-org/CitySuggest
```

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/CitySuggest", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["CitySuggest"]
    )
]
```

---

## Usage

### Check availability

Apple Intelligence must be available and enabled at runtime. Check before presenting your search UI:

```swift
import CitySuggest

let service = CitySearchService()

guard await service.isAvailable else {
    // Show a fallback UI or hide the search field
    return
}
```

### Search

```swift
do {
    let results = try await service.search("Ams")
    // → [Location(name: "Amsterdam", countryCode: "NL", ...), ...]
    for city in results {
        print("\(city.name), \(city.adminRegion), \(city.country)")
        print("Coordinates: \(city.coordinate.latitude), \(city.coordinate.longitude)")
    }
} catch {
    // Handle CitySearchError
}
```

### Reset the session

Call `reset()` when the user clears the search field or dismisses the view. This discards the underlying model session so a fresh one is created on the next search.

```swift
await service.reset()
```

---

## The `Location` type

Each result is a `Location` — a lightweight, `Sendable`, `Codable` struct:

| Property | Type | Example |
|---|---|---|
| `name` | `String` | `"Amsterdam"` |
| `adminRegion` | `String` | `"North Holland"` |
| `country` | `String` | `"Netherlands"` |
| `countryCode` | `String` | `"NL"` |
| `latitude` | `Double` | `52.3676` |
| `longitude` | `Double` | `4.9041` |
| `coordinate` | `CLLocationCoordinate2D` | *(computed)* |

The `coordinate` property is a `CLLocationCoordinate2D`, so results drop straight into MapKit annotations, `Map` region calculations, or any other CoreLocation API.

---

## Error handling

`search(_:)` throws a `CitySearchError` if Apple Intelligence is unavailable. Each case maps to a distinct recovery path:

```swift
catch let error as CitySearchError {
    switch error {
    case .deviceNotEligible:
        // Device doesn't support Apple Intelligence — show permanent fallback
    case .appleIntelligenceNotEnabled:
        // Prompt the user to enable Apple Intelligence in Settings
    case .modelNotReady:
        // Model is still downloading — try again shortly
    case .unavailable(let reason):
        // Unknown unavailability
    }
}
```

---

## Configuration

The `limit` parameter controls the maximum number of results returned per query. The default is `5`.

```swift
let service = CitySearchService(limit: 8)
```

---

## Privacy

All processing happens on-device using the system language model. No query text or results leave the user's device.

---

## License

MIT
