//
//  Models.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import Foundation
import CoreLocation
import MapKit

struct Venue: Identifiable, Codable {
    let id: UUID
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
    
    enum CodingKeys: String, CodingKey {
        case id, name, location, vibeEmojis, primaryEmoji, checkInCount, vibeStatus, category, openingHours, photos, description, priceRange
        case latitude = "coordinate.latitude"
        case longitude = "coordinate.longitude"
    }
    
    init(id: UUID = UUID(), name: String, location: String, coordinate: CLLocationCoordinate2D, vibeEmojis: [String], primaryEmoji: String, checkInCount: Int, vibeStatus: String, category: VenueCategory, openingHours: [String: String] = [:], photos: [URL] = [], description: String = "", priceRange: PriceRange = .moderate) {
        self.id = id
        self.name = name
        self.location = location
        self.coordinate = coordinate
        self.vibeEmojis = vibeEmojis
        self.primaryEmoji = primaryEmoji
        self.checkInCount = checkInCount
        self.vibeStatus = vibeStatus
        self.category = category
        self.openingHours = openingHours
        self.photos = photos
        self.description = description
        self.priceRange = priceRange
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(location, forKey: .location)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(vibeEmojis, forKey: .vibeEmojis)
        try container.encode(primaryEmoji, forKey: .primaryEmoji)
        try container.encode(checkInCount, forKey: .checkInCount)
        try container.encode(vibeStatus, forKey: .vibeStatus)
        try container.encode(category, forKey: .category)
        try container.encode(openingHours, forKey: .openingHours)
        try container.encode(photos, forKey: .photos)
        try container.encode(description, forKey: .description)
        try container.encode(priceRange, forKey: .priceRange)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        vibeEmojis = try container.decode([String].self, forKey: .vibeEmojis)
        primaryEmoji = try container.decode(String.self, forKey: .primaryEmoji)
        checkInCount = try container.decode(Int.self, forKey: .checkInCount)
        vibeStatus = try container.decode(String.self, forKey: .vibeStatus)
        category = try container.decode(VenueCategory.self, forKey: .category)
        openingHours = try container.decode([String: String].self, forKey: .openingHours)
        photos = try container.decode([URL].self, forKey: .photos)
        description = try container.decode(String.self, forKey: .description)
        priceRange = try container.decode(PriceRange.self, forKey: .priceRange)
    }
}

// MARK: - MapKit Support
class VenueAnnotationObject: NSObject, MKAnnotation {
    let venue: Venue
    
    var coordinate: CLLocationCoordinate2D { venue.coordinate }
    var title: String? { venue.name }
    var subtitle: String? { venue.location }
    
    init(venue: Venue) {
        self.venue = venue
        super.init()
    }
}

enum VenueCategory: String, CaseIterable, Codable {
    case nightclub = "Nightclub"
    case bar = "Bar"
    case lounge = "Lounge"
    case restaurant = "Restaurant"
    
    var icon: String {
        switch self {
        case .nightclub:
            return "music.note.house"
        case .bar:
            return "wineglass"
        case .lounge:
            return "sofa"
        case .restaurant:
            return "fork.knife"
        }
    }

    var systemImage: String {
        return icon
    }
}

enum PriceRange: String, CaseIterable, Codable {
    case budget = "$"
    case moderate = "$$"
    case expensive = "$$$"
    case luxury = "$$$$"
}

struct User: Identifiable, Codable {
    let id: UUID
    let username: String
    let displayName: String
    let profileImageURL: URL?
    let bio: String?
    let joinedAt: Date
    let isVerified: Bool
    
    init(id: UUID = UUID(), username: String, displayName: String, profileImageURL: URL? = nil, bio: String? = nil, joinedAt: Date = Date(), isVerified: Bool = false) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.joinedAt = joinedAt
        self.isVerified = isVerified
    }
}

struct PartyCrew: Identifiable {
    let id: UUID
    let name: String
    let members: [User]
    let venue: Venue
    let createdAt: Date
    let chatMessages: [ChatMessage]
    let isActive: Bool

    init(id: UUID = UUID(), name: String, members: [User], venue: Venue, createdAt: Date = Date(), chatMessages: [ChatMessage] = [], isActive: Bool = true) {
        self.id = id
        self.name = name
        self.members = members
        self.venue = venue
        self.createdAt = createdAt
        self.chatMessages = chatMessages
        self.isActive = isActive
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let sender: String
    let timestamp: Date
    let isFromCurrentUser: Bool
}

enum TopClubFilter: String, CaseIterable {
    case all = "All"
    case nearby = "Nearby"
    case popular = "Popular"
    case openNow = "Open Now"
    
    var systemImage: String {
        switch self {
        case .all:
            return "list.bullet"
        case .nearby:
            return "location"
        case .popular:
            return "flame"
        case .openNow:
            return "clock"
        }
    }

    var displayName: String {
        switch self {
        case .all: return "All"
        case .nearby: return "Nearby"
        case .popular: return "Popular"
        case .openNow: return "Open Now"
        }
    }
}

struct TopClubUpdate {
    let clubId: UUID
    let checkInCount: Int
    let vibeStatus: String
    let timestamp: Date

    init(clubId: UUID, checkInCount: Int, vibeStatus: String, timestamp: Date = Date()) {
        self.clubId = clubId
        self.checkInCount = checkInCount
        self.vibeStatus = vibeStatus
        self.timestamp = timestamp
    }
}

// MARK: - Type Aliases for Compatibility
typealias VenueFilter = TopClubFilter
typealias VenueUpdate = TopClubUpdate
typealias PartyGroup = PartyCrew