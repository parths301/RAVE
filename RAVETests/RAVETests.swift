//
//  RAVETests.swift
//  RAVETests
//
//  Created by Parth Sharma on 12/09/25.
//

import Testing
import CoreLocation
@testable import RAVE

struct RAVETests {

    @Test func testVenueModelInitialization() async throws {
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let venue = Venue(
            name: "Test Club",
            location: "Downtown",
            coordinate: coordinate,
            vibeEmojis: ["🔥", "💃"],
            primaryEmoji: "🔥",
            checkInCount: 25,
            vibeStatus: "🔥 Vibing",
            category: .nightclub
        )
        
        #expect(venue.name == "Test Club")
        #expect(venue.location == "Downtown")
        #expect(venue.coordinate.latitude == 37.7749)
        #expect(venue.coordinate.longitude == -122.4194)
        #expect(venue.vibeEmojis.count == 2)
        #expect(venue.primaryEmoji == "🔥")
        #expect(venue.checkInCount == 25)
        #expect(venue.category == .nightclub)
    }
    
    @Test func testVenueCategoryIcons() async throws {
        #expect(VenueCategory.nightclub.icon == "music.note.house")
        #expect(VenueCategory.bar.icon == "wineglass")
        #expect(VenueCategory.lounge.icon == "sofa")
        #expect(VenueCategory.restaurant.icon == "fork.knife")
    }
    
    @Test func testVenueFilterSystemImages() async throws {
        #expect(VenueFilter.all.systemImage == "list.bullet")
        #expect(VenueFilter.nearby.systemImage == "location")
        #expect(VenueFilter.popular.systemImage == "flame")
        #expect(VenueFilter.openNow.systemImage == "clock")
    }
    
    @Test func testUserModelInitialization() async throws {
        let user = User(
            username: "testuser",
            displayName: "Test User"
        )
        
        #expect(user.username == "testuser")
        #expect(user.displayName == "Test User")
        #expect(user.isVerified == false)
        #expect(user.bio == nil)
    }
    
    @Test func testPartyGroupModelInitialization() async throws {
        let venue = Venue(
            name: "Test Venue",
            location: "Test Location",
            coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            vibeEmojis: ["🎉"],
            primaryEmoji: "🎉",
            checkInCount: 10,
            vibeStatus: "🎉 Party",
            category: .nightclub
        )
        
        let user = User(username: "testuser", displayName: "Test User")
        let group = PartyGroup(
            name: "Test Group",
            members: [user],
            venue: venue
        )
        
        #expect(group.name == "Test Group")
        #expect(group.members.count == 1)
        #expect(group.venue.name == "Test Venue")
        #expect(group.isActive == true)
        #expect(group.chatMessages.isEmpty)
    }
    
    @Test func testChatMessageInitialization() async throws {
        let user = User(username: "sender", displayName: "Sender")
        let message = ChatMessage(
            content: "Hello world!",
            sender: user
        )
        
        #expect(message.content == "Hello world!")
        #expect(message.sender.username == "sender")
        #expect(message.messageType == .text)
    }
    
    @Test func testVenueEncodingDecoding() async throws {
        let originalVenue = Venue(
            name: "Encode Test",
            location: "Test City",
            coordinate: CLLocationCoordinate2D(latitude: 12.345, longitude: -67.890),
            vibeEmojis: ["🎵", "🔥"],
            primaryEmoji: "🎵",
            checkInCount: 42,
            vibeStatus: "🎵 Musical",
            category: .bar
        )
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encodedData = try encoder.encode(originalVenue)
        let decodedVenue = try decoder.decode(Venue.self, from: encodedData)
        
        #expect(decodedVenue.name == originalVenue.name)
        #expect(decodedVenue.location == originalVenue.location)
        #expect(decodedVenue.coordinate.latitude == originalVenue.coordinate.latitude)
        #expect(decodedVenue.coordinate.longitude == originalVenue.coordinate.longitude)
        #expect(decodedVenue.checkInCount == originalVenue.checkInCount)
        #expect(decodedVenue.category == originalVenue.category)
    }
    
    @Test func testMockVenueGeneration() async throws {
        let mockVenues = LocationManager.createMockVenues()
        
        #expect(mockVenues.count == 5)
        #expect(mockVenues.allSatisfy { !$0.name.isEmpty })
        #expect(mockVenues.allSatisfy { !$0.location.isEmpty })
        #expect(mockVenues.allSatisfy { $0.checkInCount > 0 })
        #expect(mockVenues.allSatisfy { !$0.vibeEmojis.isEmpty })
    }

}
