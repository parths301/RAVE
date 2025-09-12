//
//  LocationManager.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import Foundation
import CoreLocation
import MapKit
import Combine
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to SF
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        
        // Setup reactive updates
        setupLocationUpdates()
    }
    
    private func setupLocationUpdates() {
        // Update region when location changes
        $location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.updateRegion(for: location.coordinate)
            }
            .store(in: &cancellables)
    }
    
    func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            #if os(iOS)
            locationManager.requestWhenInUseAuthorization()
            #elseif os(macOS)
            locationManager.requestAlwaysAuthorization()
            #endif
        case .denied, .restricted:
            // Could show alert to go to settings
            break
        default:
            if isLocationAuthorized {
                startLocationUpdates()
            }
        }
    }
    
    func startLocationUpdates() {
        guard isLocationAuthorized else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation() {
        guard isLocationAuthorized else {
            requestLocationPermission()
            return
        }
        
        locationManager.requestLocation()
    }
    
    private var isLocationAuthorized: Bool {
        #if os(iOS)
        return authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
        #elseif os(macOS)
        return authorizationStatus == .authorizedAlways
        #else
        return false
        #endif
    }
    
    private func updateRegion(for coordinate: CLLocationCoordinate2D) {
        let newRegion = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        withAnimation(.easeInOut(duration: 0.5)) {
            region = newRegion
        }
    }
    
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
        guard let currentLocation = location else { return nil }
        
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return currentLocation.distance(from: targetLocation)
    }
    
    func formattedDistance(from coordinate: CLLocationCoordinate2D) -> String {
        guard let distance = distance(from: coordinate) else {
            return "Unknown"
        }
        
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter.string(fromDistance: distance)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Only update if the location is recent and accurate
        let timeInterval = newLocation.timestamp.timeIntervalSinceNow
        if abs(timeInterval) < 5 && newLocation.horizontalAccuracy < 100 {
            location = newLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                print("Location access denied")
            case .network:
                print("Network error while fetching location")
            case .locationUnknown:
                print("Unable to determine location")
            default:
                print("Unknown location error: \(clError.localizedDescription)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.authorizationStatus = status
            
            if self?.isLocationAuthorized == true {
                self?.startLocationUpdates()
            } else if status == .denied || status == .restricted {
                self?.stopLocationUpdates()
            }
        }
    }
}

// MARK: - LocationManager Extensions

extension LocationManager {
    var isLocationEnabled: Bool {
        return isLocationAuthorized
    }
    
    var locationStatusMessage: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Location access not requested"
        case .denied:
            return "Location access denied. Enable in Settings to see nearby venues."
        case .restricted:
            return "Location access restricted"
        #if os(iOS)
        case .authorizedWhenInUse:
            return "Location enabled"
        case .authorizedAlways:
            return "Location always enabled"
        #elseif os(macOS)
        case .authorizedAlways:
            return "Location enabled"
        #endif
        @unknown default:
            return "Unknown location status"
        }
    }
}

// Mock data for development and testing
extension LocationManager {
    static func createMockVenues() -> [Venue] {
        return [
            Venue(
                name: "Neon Nights",
                location: "Downtown SF",
                coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094),
                vibeEmojis: ["🔥", "💃", "🎵"],
                primaryEmoji: "🔥",
                checkInCount: 47,
                vibeStatus: "🔥 Vibing",
                category: .nightclub
            ),
            Venue(
                name: "The Purple Room",
                location: "Mission District",
                coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4194),
                vibeEmojis: ["✨", "🍸", "🎭"],
                primaryEmoji: "✨",
                checkInCount: 23,
                vibeStatus: "✨ Chill",
                category: .lounge
            ),
            Venue(
                name: "Bass Drop",
                location: "SOMA",
                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.3994),
                vibeEmojis: ["🎧", "⚡", "🕺"],
                primaryEmoji: "🎧",
                checkInCount: 78,
                vibeStatus: "⚡ Electric",
                category: .nightclub
            ),
            Venue(
                name: "Rooftop Lounge",
                location: "Financial District",
                coordinate: CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.4094),
                vibeEmojis: ["🌟", "🥂", "🌃"],
                primaryEmoji: "🌟",
                checkInCount: 31,
                vibeStatus: "🌟 Classy",
                category: .bar
            ),
            Venue(
                name: "Underground",
                location: "Castro",
                coordinate: CLLocationCoordinate2D(latitude: 37.7549, longitude: -122.4294),
                vibeEmojis: ["🔮", "🎪", "💫"],
                primaryEmoji: "🔮",
                checkInCount: 65,
                vibeStatus: "🔮 Mystical",
                category: .nightclub
            )
        ]
    }
}