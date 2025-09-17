
# RAVE - Native Swift iOS Nightlife Social App

## Project Overview

RAVE is a native iOS social networking app for nightlife, built with SwiftUI for iOS 17+. The app helps users discover venues, connect with friends, and share their nightlife experiences. It features a dark, neon-themed UI and leverages several of Apple's native frameworks, including MapKit, CoreLocation, and UserNotifications.

The app is structured around a main tab bar with four key sections:

*   **Map:** A real-time map showing nearby venues and user activity.
*   **Top Clubs:** A curated list of popular venues.
*   **Crew:** A feature for creating and managing groups of friends.
*   **Alerts:** A notification center for social updates and venue activity.

## Building and Running

This is an Xcode project. To build and run the app:

1.  Open `RAVE.xcodeproj` in Xcode.
2.  Select a target device or simulator.
3.  Click the "Run" button.

*TODO: Add any specific build configurations or environment variables required to run the app.*

## Development Conventions

### Coding Style

The codebase is written in Swift and follows standard Swift conventions. The UI is built with SwiftUI, and the code is organized into views, models, and managers.

### Testing

The project includes unit tests (`RAVETests`) and UI tests (`RAVEUITests`).

*   **Unit Tests:** Run the unit tests to verify the functionality of individual components.
*   **UI Tests:** Run the UI tests to ensure the app's user interface behaves as expected.

*TODO: Add instructions on how to run the tests from the command line.*

### Key Files

*   `RAVE/RAVEApp.swift`: The main entry point of the app.
*   `RAVE/ContentView.swift`: The root view of the app, containing the main tab bar.
*   `RAVE/Models.swift`: The data models for the app.
*   `RAVE/MapView.swift`: The main map view.
*   `RAVE/TopClubsView.swift`: The view for the "Top Clubs" tab.
*   `RAVE/CrewView.swift`: The view for the "Crew" tab.
*   `RAVE/AlertsView.swift`: The view for the "Alerts" tab.
*   `RAVE-prompt.md`: A detailed project brief.
*   `RAVE-Navigation-Map.md`: A document outlining the app's navigation and feature map.
*   `RAVE/DesignSystem.swift`: A file that defines the app's color scheme, typography, and custom UI components.
*   `RAVE/LocationManager.swift`: A class that manages the app's location services.
*   `RAVE/VenueComponents.swift`: A collection of reusable SwiftUI views for displaying venue information.
*   `RAVE/AppleHIGuidelines.md`: A document that outlines the project's commitment to Apple's Human Interface Guidelines.

## Design System

The app features a custom design system defined in `RAVE/DesignSystem.swift`. It includes:

*   **Colors:** A dark-themed color palette with a neon purple accent.
*   **Typography:** A custom typography system based on Apple's San Francisco font family.
*   **Button Styles:** A set of custom button styles for primary, secondary, and tertiary actions.
*   **UI Components:** A collection of reusable UI components, such as cards, lists, and empty state views.

## Location Services

The app uses CoreLocation to provide location-based features, such as showing nearby venues on the map. The `LocationManager` class in `RAVE/LocationManager.swift` encapsulates the app's location-related logic, including:

*   Requesting location permissions from the user.
*   Starting and stopping location updates.
*   Providing the user's current location to other parts of the app.

## UI Components

The app uses a variety of custom SwiftUI views to create its user interface. The `RAVE/VenueComponents.swift` file contains a collection of reusable views for displaying venue information, such as:

*   `VenueDetailView`: A view that displays detailed information about a venue.
*   `AppleStatCard`: A card-style view for displaying statistics.
*   `VibeBadge`: A badge for displaying the current vibe of a venue.

## Apple HIG Adherence

The project is committed to following Apple's Human Interface Guidelines (HIG) to ensure a consistent and intuitive user experience. The `RAVE/AppleHIGuidelines.md` file outlines the project's approach to adhering to the HIG, including guidelines for layout, typography, color, and accessibility.

## Project Elements and Groups

### I. Project Structure & High-Level Groups

*   **RAVE (Main App Group):** Contains all the source code for the application.
*   **RAVE.xcodeproj:** The Xcode project file that organizes all files and settings.
*   **RAVETests:** The target for unit tests.
*   **RAVEUITests:** The target for UI tests.
*   **Documentation:** A collection of Markdown files that define the project's specifications, navigation, and coding guidelines.

### II. Application & Core Elements

*   **`RAVEApp.swift`:** The main entry point of the application, conforming to the `App` protocol.
*   **`ContentView.swift`:** The root view of the app, which sets up the main `TabView`.
*   **`RAVE.entitlements`:** A file that specifies the app's capabilities and permissions.
*   **Project Documentation:**
    *   **`GEMINI.md`:** Documentation for the Gemini AI agent.
    *   **`CLAUDE.md`**: Documentation for the Claude AI agent.
    *   **`RAVE-prompt.md`:** A detailed project brief outlining features, design, and technical specifications.
    *   **`RAVE-Navigation-Map.md`:** A map of the app's navigation flow and feature connections.

### III. Main Views (Tabs)

The app's primary navigation is a `TabView` with the following tabs:

1.  **Map:**
    *   **View:** `MapView.swift`
    *   **Components:** `MapViewContent`, `HamburgerMenuButton`, `AppleVenueAnnotation`, `AppleLocationPermissionView`, `AppleVenueCardView`.
2.  **Top Clubs:**
    *   **View:** `TopClubsView.swift`
    *   **Components:** `TopClubsViewContent`, `AppleTopClubRowView`.
3.  **Crew (Groups):**
    *   **View:** `CrewView.swift` (and the similar `GroupsView.swift`)
    *   **Components:** `CrewViewContent`, `CrewNotificationsView`, `AppleCrewRowView`, `AppleCrewDetailView`, `AppleCreateCrewView`, `FriendSelectionView`, `AppleCrewChatView`.
4.  **Alerts (Notifications):**
    *   **View:** `AlertsView.swift`
    *   **Components:** `AlertsViewContent`, `AppleAlertRowView`, `AppleNotificationSettingsView`.

### IV. Detailed Views & Screens

These views are typically navigated to from the main tabs or the hamburger menu:

*   **`HamburgerMenuView.swift`:** A slide-out menu for accessing secondary screens.
*   **`UserProfileView.swift`:** The user's profile screen.
*   **`UserStatsView.swift`:** A screen for displaying user statistics.
*   **`EventHistoryView.swift`:** A log of the user's past events.
*   **`FriendsView.swift`:** A screen for managing friends and friend requests.
*   **`PremiumView.swift`:** The paywall and feature showcase for the premium version.
*   **`SettingsView.swift`:** A screen for app-wide settings.
*   **`PrivacyView.swift`:** A screen for managing privacy settings.
*   **`HelpView.swift`:** A help and support screen.
*   **`VenueDetailView.swift`:** A detailed view of a specific venue.

### V. Data Models (`Models.swift`)

These structs and enums define the data structures used throughout the app:

*   **`Venue`**: Represents a physical location.
*   **`User`**: Represents an app user.
*   **`VenueCrew` / `PartyCrew` / `VenueGroup`**: Represents a social group.
*   **`ChatMessage`**: Represents a message in a chat.
*   **`VenueAlert` / `CrewAlert`**: Represents a notification.
*   **`Friend` / `FriendRequest`**: Represents a user's friend and friend requests.
*   **`EventHistory`**: Represents a past event attended by the user.
*   **`UserStats` / `Achievement` / `MusicPreference`**: Represents user statistics and preferences.
*   **Enums:** `VenueCategory`, `PriceRange`, `TopClubFilter`, `CrewCategory`, `AlertType`, etc.

### VI. Managers & Services

*   **`LocationManager.swift`:** Manages location services using `CoreLocation`.
*   **`VenueManager` & `NotificationManager`:** (Defined in documentation) Classes intended to manage venues and notifications.

### VII. Design System & UI Components

*   **`DesignSystem.swift`:** Defines the app's visual style.
    *   **Colors:** A custom color palette for the dark theme.
    *   **Typography:** A custom typography system.
    *   **Styles:** `AppleButtonStyle`, `AppleListStyle`, etc.
    *   **Reusable Views:** `AppleEmptyStateView`, `AppleToggle`, `AppleTextField`, etc.
*   **`VenueComponents.swift`:** A collection of reusable views for displaying venue information.

### VIII. Testing

*   **`RAVETests.swift`:** Unit tests for the app's data models and business logic.
*   **`RAVEUITests.swift`:** UI tests for simulating user interaction and verifying the app's UI.
*   **`RAVEUITestsLaunchTests.swift`:** Tests for the app's launch performance.

### IX. Assets (`Assets.xcassets`)

*   **`AccentColor`:** The main accent color for the app.
*   **`AppIcon`:** The icon for the app.
*   **`RAVElogo.png`:** The logo for the RAVE brand.
