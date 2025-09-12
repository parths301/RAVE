//
//  RAVEUITests.swift
//  RAVEUITests
//
//  Created by Parth Sharma on 12/09/25.
//

import XCTest

final class RAVEUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Test that all tab bar items are present
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists)
        
        // Test Map tab
        let mapTab = tabBar.buttons["Map"]
        XCTAssertTrue(mapTab.exists)
        mapTab.tap()
        
        // Test Top Clubs tab
        let topClubsTab = tabBar.buttons["Top Clubs"]
        XCTAssertTrue(topClubsTab.exists)
        topClubsTab.tap()
        
        // Verify search functionality exists
        let searchField = app.textFields.matching(identifier: "Search venues, locations...").firstMatch
        XCTAssertTrue(searchField.exists)
        
        // Test Groups tab
        let groupsTab = tabBar.buttons["Groups"]
        XCTAssertTrue(groupsTab.exists)
        groupsTab.tap()
        
        // Test Alerts tab
        let alertsTab = tabBar.buttons["Alerts"]
        XCTAssertTrue(alertsTab.exists)
        alertsTab.tap()
    }
    
    @MainActor
    func testMapViewInteraction() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Map tab
        let mapTab = app.tabBars.buttons["Map"]
        mapTab.tap()
        
        // Check if navigation title exists
        let navTitle = app.navigationBars["RAVE"]
        XCTAssertTrue(navTitle.exists)
        
        // Check if location button exists
        let locationButton = app.buttons.matching(identifier: "location").firstMatch
        XCTAssertTrue(locationButton.exists)
    }
    
    @MainActor
    func testTopClubsSearch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Top Clubs tab
        let topClubsTab = app.tabBars.buttons["Top Clubs"]
        topClubsTab.tap()
        
        // Test search functionality
        let searchField = app.textFields.firstMatch
        if searchField.exists {
            searchField.tap()
            searchField.typeText("Club")
            
            // Test that clear button appears
            let clearButton = app.buttons.matching(identifier: "xmark.circle.fill").firstMatch
            XCTAssertTrue(clearButton.exists)
            
            clearButton.tap()
        }
    }
    
    @MainActor
    func testGroupsEmptyState() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Groups tab
        let groupsTab = app.tabBars.buttons["Groups"]
        groupsTab.tap()
        
        // Check if plus button exists for creating groups
        let createGroupButton = app.buttons.matching(identifier: "plus").firstMatch
        XCTAssertTrue(createGroupButton.exists)
    }
    
    @MainActor
    func testAlertsView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Alerts tab
        let alertsTab = app.tabBars.buttons["Alerts"]
        alertsTab.tap()
        
        // Check if notification toggle button exists
        let notificationButton = app.buttons.containing(NSPredicate(format: "identifier CONTAINS 'bell'")).firstMatch
        XCTAssertTrue(notificationButton.exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
