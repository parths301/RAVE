# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**RAVE** is a native iOS SwiftUI application for nightlife social networking. This is currently a new project with minimal implementation - most functionality exists as detailed specifications in `RAVE/RAVE-prompt.md`.

## Development Environment

- **Platform**: iOS 17+ with SwiftUI
- **Language**: Swift 5.9+
- **IDE**: Xcode 16.4+
- **Architecture**: SwiftUI with MVVM pattern
- **Target Devices**: iPhone (primary focus on iPhone 14 Pro and newer)
- **Deployment**: iOS 18.5+, macOS 15.5+, visionOS 2.5+

## Project Structure

```
RAVE/
├── RAVE.app                    # Main app target
├── RAVETests/                  # Unit tests
├── RAVEUITests/                # UI tests  
└── RAVE/
    ├── RAVEApp.swift          # App entry point
    ├── ContentView.swift      # Main view (placeholder)
    ├── RAVE-prompt.md         # Comprehensive app specification
    ├── RAVE.entitlements      # App entitlements
    └── Assets.xcassets/       # App icons and assets
```

## Build Commands

**Build the app:**
```bash
xcodebuild -project RAVE.xcodeproj -scheme RAVE build
```

**Run unit tests:**
```bash
xcodebuild test -project RAVE.xcodeproj -scheme RAVE -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

**Run UI tests:**
```bash
xcodebuild test -project RAVE.xcodeproj -scheme RAVE -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:RAVEUITests
```

**Clean build:**
```bash
xcodebuild clean -project RAVE.xcodeproj -scheme RAVE
```

## Architecture Guidelines

### Core Technologies Integration
- **MapKit**: Real-time location and venue mapping
- **CoreLocation**: Location services with privacy controls
- **Combine**: Reactive programming for real-time updates
- **SwiftData/CoreData**: Local data persistence
- **UserNotifications**: Push notifications for events
- **Sign in with Apple**: Primary authentication

### UI/UX Standards
- **Design System**: Dark theme with neon purple accents (#A16EFF)
- **Typography**: SF Pro font family throughout
- **Navigation**: Bottom TabView with 4 main sections (Map, Top Clubs, Groups, Alerts)
- **Components**: Custom venue cards, map annotations, search filters

### Key Views Architecture
1. **MapView** - Primary screen with MapKit integration
2. **TopClubsView** - Venue discovery with search and filters  
3. **GroupsView** - Social party groups functionality
4. **AlertsView** - Real-time notifications and updates

### Testing Framework
- **Unit Tests**: Using Swift Testing framework (`@Test` syntax)
- **UI Tests**: XCUITest for user interaction testing
- **Test Targets**: RAVETests (unit) and RAVEUITests (UI)

## Development Notes

### Current State
This is a newly created project with basic SwiftUI boilerplate. The main implementation work is ahead, guided by the comprehensive specifications in `RAVE/RAVE-prompt.md`.

### Privacy & Permissions
Required Info.plist permissions:
- Location services (when in use)
- Camera access (photo sharing)
- Microphone access (audio messages)
- Push notifications

### App Store Configuration
- **Bundle ID**: com.RAVE
- **Age Rating**: 17+ (mature themes)
- **Platforms**: iOS, macOS, visionOS
- **Version**: 1.0 (development)