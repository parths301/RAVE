# RAVE - Native Swift iOS Nightlife Social App

Create a native Swift iOS app for nightlife social networking with the following comprehensive specifications:

## App Overview
**App Name:** RAVE  
**Platform:** iOS 17+ (Swift 5.9+, SwiftUI)  
**Device Support:** iPhone 14 Pro and newer (1179 x 2556 px primary target)

## Apple Native Features Integration

### Core iOS Features
- **MapKit Integration:** Native Apple Maps with custom annotations and overlays
- **CoreLocation:** Real-time location services with privacy-first approach
- **UserNotifications:** Push notifications for events and group activities
- **CoreData/SwiftData:** Local data persistence and sync
- **Combine Framework:** Reactive programming for real-time updates
- **AVFoundation:** Audio integration for venue previews
- **PassKit:** Event ticket integration
- **EventKit:** Calendar integration for events
- **Contacts:** Contact sharing for group invitations
- **ShareSheet:** Native sharing functionality

### Modern iOS UI Components
- **Navigation Stack:** iOS 16+ navigation with smooth transitions
- **Tab View:** Native bottom tab navigation
- **Sheet Presentations:** Bottom sheets and modals
- **Contextual Menus:** Long-press actions on venue pins
- **Search:** Native search with suggestions and filters
- **List with Sections:** Grouped venue listings
- **Pull to Refresh:** Native refresh controls
- **Haptic Feedback:** Tactical feedback for interactions

### Privacy & Security
- **App Tracking Transparency:** Permission requests
- **Location Privacy:** Precise/approximate location options
- **Privacy Nutrition Labels:** App Store compliance
- **Sign in with Apple:** Primary authentication method
- **Keychain Services:** Secure credential storage

## Visual Design Specifications

### Typography (SF Pro Font Family)
```swift
// Font Hierarchy
.largeTitle: SF Pro Display Bold (34pt) - App name, major headings
.title: SF Pro Display Bold (28pt) - Screen titles
.title2: SF Pro Display Bold (22pt) - Section headers
.headline: SF Pro Display Semibold (17pt) - Venue names
.body: SF Pro Text Regular (17pt) - Standard text
.callout: SF Pro Text Medium (16pt) - Labels, metadata
.subheadline: SF Pro Text Regular (15pt) - Secondary info
.footnote: SF Pro Text Regular (13pt) - Check-in counts
.caption: SF Pro Text Regular (12pt) - Timestamps
```

### Color System (iOS Dynamic Colors)
```swift
// Primary Colors
let ravePurple = Color(hex: "A16EFF") // Neon purple accent
let darkBackground = Color(hex: "0A0A0A") // Main background
let cardBackground = Color(hex: "1A1A1A") // Card/panel background

// iOS System Colors Integration
let primaryText = Color.primary // Adapts to dark/light mode
let secondaryText = Color.secondary
let tertiaryText = Color(.tertiaryLabel)
let systemBackground = Color(.systemBackground)
let groupedBackground = Color(.systemGroupedBackground)
```

### App Icon & Branding
- **App Icon:** 1024x1024px with neon purple gradient
- **Launch Screen:** Dark background with animated RAVE logo
- **SF Symbols:** Use throughout for consistent iconography

## Screen Structure & Navigation

### Main Tab Bar (Bottom Navigation)
```swift
TabView {
    MapView()
        .tabItem {
            Image(systemName: "map.fill")
            Text("Map")
        }
    
    TopClubsView()
        .tabItem {
            Image(systemName: "crown.fill")
            Text("Top Clubs")
        }
    
    GroupsView()
        .tabItem {
            Image(systemName: "person.3.fill")
            Text("Groups")
        }
    
    AlertsView()
        .tabItem {
            Image(systemName: "bell.fill")
            Text("Alerts")
        }
}
.tint(ravePurple) // Active tab color
```

### Key Views Architecture

#### 1. MapView (Primary Screen)
```swift
struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedVenue: Venue?
    @State private var showVenueDetail = false
    
    var body: some View {
        ZStack {
            // MapKit Integration
            Map(coordinateRegion: $region, annotationItems: venues) { venue in
                MapAnnotation(coordinate: venue.coordinate) {
                    VenueAnnotation(venue: venue)
                        .onTapGesture {
                            selectedVenue = venue
                            showVenueDetail = true
                        }
                }
            }
            .mapStyle(.standard(emphasis: .muted))
            .preferredColorScheme(.dark)
            
            // Bottom Sheet for Selected Venue
            if let selectedVenue = selectedVenue {
                VStack {
                    Spacer()
                    VenueCardView(venue: selectedVenue)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .padding()
                }
            }
        }
        .navigationTitle("RAVE")
        .navigationBarTitleDisplayMode(.large)
    }
}
```

#### 2. Venue Cards Component
```swift
struct VenueCardView: View {
    let venue: Venue
    @State private var isJoining = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(venue.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(venue.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Vibe Emojis
                HStack(spacing: 4) {
                    ForEach(venue.vibeEmojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.title2)
                    }
                }
            }
            
            // Check-in Status
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.secondary)
                Text("\(venue.checkInCount) checked in tonight")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                // Vibe Badge
                Text("🔥 Vibing")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ravePurple.opacity(0.2))
                    .foregroundColor(ravePurple)
                    .clipShape(Capsule())
            }
            
            // Action Button
            Button(action: joinPartyGroup) {
                HStack {
                    if isJoining {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "person.2.badge.plus")
                        Text("Join Party Group")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(ravePurple)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isJoining)
            .buttonStyle(.plain)
            .sensoryFeedback(.impact, trigger: isJoining)
        }
        .padding()
    }
}
```

#### 3. Custom Map Annotations
```swift
struct VenueAnnotation: View {
    let venue: Venue
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Pulsing Background
            Circle()
                .fill(ravePurple.opacity(0.3))
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)
            
            // Main Pin
            VStack(spacing: 2) {
                Text(venue.primaryEmoji)
                    .font(.title2)
                
                Text(venue.name.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ravePurple, lineWidth: 2)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}
```

## Advanced Features Implementation

### Real-time Updates with Combine
```swift
class VenueManager: ObservableObject {
    @Published var venues: [Venue] = []
    @Published var realTimeUpdates: [String: VenueUpdate] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    private let websocketService = WebSocketService()
    
    init() {
        setupRealTimeUpdates()
    }
    
    private func setupRealTimeUpdates() {
        websocketService.updates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] update in
                self?.handleVenueUpdate(update)
            }
            .store(in: &cancellables)
    }
}
```

### Location Services Integration
```swift
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // Delegate methods...
}
```

### Push Notifications
```swift
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    func requestPermission() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            if granted {
                await registerForRemoteNotifications()
            }
        } catch {
            print("Permission denied: \(error)")
        }
    }
    
    @MainActor
    func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
}
```

## UI/UX Enhancements

### Custom Transitions and Animations
```swift
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
```

### Search and Filtering
```swift
struct ClubSearchView: View {
    @State private var searchText = ""
    @State private var selectedFilters: Set<VenueFilter> = []
    
    var body: some View {
        NavigationStack {
            VStack {
                // Native Search Bar
                SearchBar(text: $searchText)
                    .searchSuggestions {
                        ForEach(searchSuggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .searchCompletion(suggestion)
                        }
                    }
                
                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(VenueFilter.allCases, id: \.self) { filter in
                            FilterChip(filter: filter, isSelected: selectedFilters.contains(filter))
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Results List
                List(filteredVenues) { venue in
                    NavigationLink(destination: VenueDetailView(venue: venue)) {
                        VenueRowView(venue: venue)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Top Clubs")
        }
    }
}
```

## Data Models

```swift
struct Venue: Identifiable, Codable {
    let id = UUID()
    let name: String
    let location: String
    let coordinate: CLLocationCoordinate2D
    let vibeEmojis: [String]
    let primaryEmoji: String
    let checkInCount: Int
    let vibeStatus: String
    let category: VenueCategory
    let openingHours: [String: String]
    let photos: [URL]
    let description: String
    let priceRange: PriceRange
}

enum VenueCategory: String, CaseIterable {
    case nightclub = "Nightclub"
    case bar = "Bar"
    case lounge = "Lounge"
    case restaurant = "Restaurant"
}

struct PartyGroup: Identifiable {
    let id = UUID()
    let name: String
    let members: [User]
    let venue: Venue
    let createdAt: Date
    let chatMessages: [ChatMessage]
}
```

## Testing & Quality Assurance

### Unit Testing with XCTest
```swift
class VenueManagerTests: XCTestCase {
    var venueManager: VenueManager!
    
    override func setUpWithError() throws {
        venueManager = VenueManager()
    }
    
    func testVenueFiltering() throws {
        // Test venue filtering logic
    }
    
    func testLocationCalculations() throws {
        // Test distance calculations
    }
}
```

### UI Testing
```swift
class RAVEUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }
    
    func testMapNavigation() throws {
        // Test map interaction
    }
    
    func testVenueSelection() throws {
        // Test venue card interactions
    }
}
```

## Deployment & App Store Requirements

### Info.plist Configuration
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>RAVE uses your location to show nearby venues and events.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>RAVE needs location access to provide personalized venue recommendations.</string>

<key>NSCameraUsageDescription</key>
<string>Take photos to share your nightlife experiences.</string>

<key>NSMicrophoneUsageDescription</key>
<string>Record audio messages in party groups.</string>
```

### App Store Optimization
- **Keywords:** nightlife, clubs, social, events, party
- **Screenshots:** Feature map view, venue cards, group chat
- **App Preview:** 30-second video showcasing core features
- **Age Rating:** 17+ (frequent/intense mature themes)

This comprehensive prompt provides a complete roadmap for building a native Swift iOS app that leverages Apple's ecosystem while maintaining the dark, neon aesthetic and nightlife social features of RAVE.