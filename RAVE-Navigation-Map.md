# RAVE App - Navigation & Feature Map 🗺️

This document explains how all the features in the RAVE app are connected and where to find everything. Think of it as a friendly guide that anyone can understand, even if you've never coded before!

## 🏠 Main App Structure

RAVE has a simple structure with 4 main tabs at the bottom:

```
📱 RAVE App
├── 🗺️ Map (Main screen)
├── 👑 Top Clubs
├── 👥 Crew
└── 🔔 Alerts
```

## 🍔 Side Menu (Hamburger Menu)

The hamburger menu (☰) is located in the **top-left corner** of the Map view and gives you access to all the important features:

### 👤 Profile & Account
- **Profile** → View and edit your personal information
- **Settings** → Customize app behavior and preferences
- **Privacy** → Control who sees what about you

### 🤝 Social Features  
- **Friends** → Manage your friend list, send/receive friend requests
- **Statistics** → See your nightlife activity and achievements
- **Event History** → Look back at all the places you've been

### 📚 Help & Premium
- **Help & Support** → Get answers to questions and contact support
- **Premium** → Upgrade to unlock special features
- **Share App** → Tell your friends about RAVE
- **Sign Out** → Log out of your account

## 🌊 Navigation Flow - How Everything Connects

### Starting Point: Map View 🗺️
This is where everyone begins their RAVE journey!

**From Map, you can:**
- Tap **☰ (hamburger menu)** → Access all menu features
- Tap **venue annotations** → See venue details
- Use **location button** → Center map on your location

### Top Clubs View 👑
**Features available:**
- **Search bar** → Find specific venues
- **Filter chips** (All, Nearby, Popular, Open Now)
- **Venue list** → Tap any venue → Goes to **VenueDetailView**

### Crew View 👥
**Features available:**
- **Crew list** → Tap any crew → Goes to **CrewDetailView**
- **+ button** → Create new crew
- **"Quick Chat" section** → Tap "View All" → Goes to **CrewChatView**

**From CrewChatView, you can:**
- Send messages in real-time
- Tap **⋯ menu** → Access crew options:
  - Add Members
  - Plan RAVE
  - Crew Settings  
  - Leave Crew (destructive action)

### Alerts View 🔔
**Features available:**
- **Alert list** → Tap alerts to mark as read
- **⋯ menu** → Enable/disable notifications or clear all
- **"Clear All Alerts" button** → Remove all alerts at once

## 🔗 Deep Navigation Connections

### From Side Menu → Detailed Views

#### Profile Journey 👤
```
Map → ☰ → Profile → UserProfileView
                  ├── Edit mode (tap "Edit")
                  ├── Change photo
                  ├── Edit bio and location
                  └── Music preferences
```

#### Settings Journey ⚙️
```
Map → ☰ → Settings → SettingsView
                   ├── Notification Settings
                   ├── Privacy Settings
                   ├── Account Settings
                   └── Various toggles and sliders
```

#### Privacy Journey 🔒
```
Map → ☰ → Privacy → PrivacyView
                 ├── Profile visibility settings
                 ├── Location sharing controls  
                 ├── Blocked Users → BlockedUsersView
                 └── Data Management → DataManagementView
```

#### Friends Journey 👥
```
Map → ☰ → Friends → FriendsView
                  ├── Tab 1: Friends List → FriendDetailView
                  ├── Tab 2: Friend Requests (Accept/Decline)
                  └── Tab 3: Discover Friends (Add new friends)
```

#### Statistics Journey 📊
```
Map → ☰ → Statistics → UserStatsView
                     ├── Period selector (Week/Month/Year/All Time)
                     ├── Stats cards with trends
                     ├── Top venues ranking
                     ├── Activity timeline
                     ├── Achievement badges
                     └── Music preference charts
```

#### Event History Journey 📅
```
Map → ☰ → Event History → EventHistoryView
                        ├── Filter by time period
                        ├── View past events
                        ├── See crew members from each event
                        └── Read personal memories/notes
```

#### Help Journey ❓
```
Map → ☰ → Help & Support → HelpView
                         ├── Quick actions (Contact, Report Bug)
                         ├── Expandable FAQ sections
                         ├── Community Guidelines
                         ├── Safety Tips
                         └── App information
```

#### Premium Journey ⭐
```
Map → ☰ → Premium → PremiumView
                  ├── Feature showcase
                  ├── Pricing plans (Monthly/Yearly)
                  ├── Purchase flow → PurchaseFlowView
                  └── Terms and restore options
```

## 🎯 Key Features by View

### Map View Features 🗺️
- **Real-time venue locations** with custom annotations
- **Translucent header gradient** (fixed to stay at top)
- **RAVE title** with custom letter spacing
- **Hamburger menu** for navigation
- **Location services** integration
- **Venue selection** with bottom sheet details
- **Particle effects** for premium feel

### Top Clubs Features 👑
- **Native searchable** functionality
- **Filter system** (All, Nearby, Popular, Open Now)
- **Venue cards** with ratings and distance
- **Navigation to venue details**
- **Consistent spacing** with other list views

### Crew Features 👥
- **Group management** (create, join, leave)
- **Real-time chat** with message bubbles
- **Member management** (add/remove members)
- **Event planning** capabilities
- **Activity sharing** within crews

### Alerts Features 🔔
- **Real-time notifications** for venue activity
- **Group invitations** and social updates
- **Notification management** (mark read, clear all)
- **Settings integration** for notification preferences
- **Expandable alert details**

## 🔄 Data Flow - How Information Moves

### User Data Flow
```
Profile Edit → Updates across all views
Settings Changes → Affects app behavior globally  
Privacy Settings → Controls visibility everywhere
Friend Actions → Updates social features
```

### Social Data Flow
```
Crew Creation → Appears in Crew list
Chat Messages → Real-time updates in CrewChatView
Check-ins → Creates alerts for friends
Event Attendance → Adds to Event History
```

### Location Data Flow
```
User Location → Map positioning
Venue Discovery → Top Clubs list
Friend Locations → Social features
Check-in Data → Statistics and history
```

## 🎨 Design Consistency

All views follow the same design principles:

- **Dark theme** with rave purple accents (#A16EFF)
- **Glassmorphism effects** for cards and overlays
- **Particle animations** (can be disabled for performance)
- **Native SwiftUI components** for familiar iOS feel
- **Consistent spacing** and typography
- **Smooth animations** for all interactions

## 🔒 Privacy & Security Features

### User Control
- **Profile visibility** (Everyone/Friends/Private)
- **Location sharing** controls
- **Online status** visibility toggle
- **Activity sharing** preferences

### Safety Features
- **Block users** functionality
- **Report content** options
- **Data export** capabilities
- **Account deletion** process

### Data Management
- **Clear cache** options
- **Export personal data**
- **Manage connected accounts**
- **Two-factor authentication** setup

## 🏆 Gamification Elements

### Achievement System
- **Badges** for various activities
- **Statistics tracking** (venues visited, events attended)
- **Leaderboards** (top venues, activity levels)
- **Progress indicators** for goals

### Social Competition
- **Crew statistics** comparison
- **Venue check-in** counts
- **Activity sharing** with friends
- **Achievement showcasing**

## 📱 Premium Features Integration

Premium features are seamlessly integrated throughout:

- **Enhanced analytics** in Statistics view
- **Advanced privacy controls** in Privacy settings
- **VIP status indicators** throughout the app
- **Priority support** access in Help section
- **Exclusive content** access in various views

---

## 🎯 For Non-Technical People: How to Use RAVE

Think of RAVE like your nightlife command center:

1. **Start with the Map** - See what's happening around you
2. **Use the Hamburger Menu (☰)** - Access all your personal stuff  
3. **Check Top Clubs** - Find the best places to go
4. **Join or Create Crews** - Go out with friends
5. **Stay Updated with Alerts** - Never miss the action

Everything is connected, so when you do something in one place (like join a crew), it shows up everywhere else it's relevant. It's designed to be intuitive - if you think "I want to do X," there's probably a clear path to do it!

The app learns from what you like and helps you discover new places and meet new people, all while keeping your privacy and safety as the top priority. 🎉