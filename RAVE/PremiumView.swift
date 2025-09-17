//
//  PremiumView.swift
//  RAVE
//
//  Created by Claude on 12/09/25.
//

import SwiftUI

struct PremiumView: View {
    @State private var selectedPlan: PremiumPlan = .monthly
    @State private var showingPurchase = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 16) {
                    // Premium Crown Icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.yellow.opacity(0.3), .orange.opacity(0.2), .clear],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 80
                                )
                            )
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.yellow)
                            .shadow(color: .yellow.opacity(0.6), radius: 10, x: 0, y: 0)
                    }
                    
                    VStack(spacing: 8) {
                        Text("RAVE Premium")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Unlock the ultimate nightlife experience")
                            .font(.system(size: 18))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Features List
                VStack(spacing: 20) {
                    PremiumFeatureView(
                        icon: "eye.fill",
                        title: "Advanced Venue Insights",
                        description: "See real-time crowd levels, music genres, and age demographics before you arrive",
                        gradient: LinearGradient(colors: [.appPrimary, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    PremiumFeatureView(
                        icon: "star.circle.fill",
                        title: "VIP Status & Perks",
                        description: "Skip lines, access exclusive events, and get priority reservations at partner venues",
                        gradient: LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    PremiumFeatureView(
                        icon: "shield.lefthalf.filled",
                        title: "Enhanced Privacy Controls",
                        description: "Advanced privacy settings, invisible mode, and complete control over your data",
                        gradient: LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    PremiumFeatureView(
                        icon: "chart.bar.doc.horizontal.fill",
                        title: "Detailed Analytics",
                        description: "Track your nightlife patterns, favorite venues, and social connections with rich insights",
                        gradient: LinearGradient(colors: [.pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    PremiumFeatureView(
                        icon: "person.2.badge.gearshape.fill",
                        title: "Priority Support",
                        description: "Get help faster with dedicated premium support and early access to new features",
                        gradient: LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    
                    PremiumFeatureView(
                        icon: "sparkles",
                        title: "Exclusive Content",
                        description: "Access premium events, early venue previews, and exclusive RAVE community features",
                        gradient: LinearGradient(colors: [.indigo, .appPrimary], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                }
                
                // Pricing Plans
                VStack(spacing: 16) {
                    Text("Choose Your Plan")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        PremiumPlanCard(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly,
                            onSelect: { selectedPlan = .monthly }
                        )
                        
                        PremiumPlanCard(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly,
                            onSelect: { selectedPlan = .yearly }
                        )
                    }
                }
                
                // Subscribe Button
                Button(action: {
                    showingPurchase = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 20))
                        
                        Text("Start Premium - \(selectedPlan.displayPrice)")
                            .font(.system(size: 18, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [.white.opacity(0.4), .clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        }
                    )
                    .foregroundColor(.black)
                    .shadow(color: .yellow.opacity(0.3), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal)
                
                // Terms and restore
                VStack(spacing: 12) {
                    Text("7-day free trial, then \(selectedPlan.displayPrice). Cancel anytime.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 24) {
                        Button("Terms of Service") {
                            // Show terms
                        }
                        .font(.caption)
                        .foregroundColor(.appPrimary)
                        
                        Button("Privacy Policy") {
                            // Show privacy policy
                        }
                        .font(.caption)
                        .foregroundColor(.appPrimary)
                        
                        Button("Restore Purchase") {
                            // Restore purchases
                        }
                        .font(.caption)
                        .foregroundColor(.appPrimary)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.appBackground.ignoresSafeArea())
        .sheet(isPresented: $showingPurchase) {
            PurchaseFlowView(selectedPlan: selectedPlan)
        }
    }
}

struct PremiumFeatureView: View {
    let icon: String
    let title: String
    let description: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack(spacing: 16) {
            // Feature Icon
            ZStack {
                Circle()
                    .fill(gradient.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }
            
            // Feature Details
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding()
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.appSecondaryBackground)
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial.opacity(0.5))
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .padding(.horizontal)
    }
}

struct PremiumPlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Selection Indicator
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(.yellow)
                            .frame(width: 16, height: 16)
                    }
                }
                
                // Plan Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        if plan == .yearly {
                            Text("SAVE 40%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.yellow)
                                .cornerRadius(8)
                        }
                    }
                    
                    Text(plan.subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Price
                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.displayPrice)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    if plan == .yearly {
                        Text("$4.17/month")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.appSecondaryBackground)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial.opacity(0.5))
                    
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected ? .yellow : .white.opacity(0.2),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct PurchaseFlowView: View {
    let selectedPlan: PremiumPlan
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                // Processing or Success State
                if isProcessing {
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.yellow)
                        
                        Text("Processing your subscription...")
                            .font(.headline)
                    }
                } else {
                    VStack(spacing: 24) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.yellow)
                        
                        Text("Welcome to Premium!")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("You now have access to all premium features")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                Button(isProcessing ? "Processing..." : "Get Started") {
                    if !isProcessing {
                        withAnimation {
                            isProcessing = true
                        }
                        
                        // Simulate purchase process
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            dismiss()
                        }
                    }
                }
                .disabled(isProcessing)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.yellow)
                .foregroundColor(.black)
                .cornerRadius(16)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Complete Purchase")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isProcessing)
                }
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

enum PremiumPlan: CaseIterable {
    case monthly
    case yearly
    
    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
    
    var subtitle: String {
        switch self {
        case .monthly: return "Billed monthly"
        case .yearly: return "Billed annually"
        }
    }
    
    var displayPrice: String {
        switch self {
        case .monthly: return "$9.99/month"
        case .yearly: return "$49.99/year"
        }
    }
    
    var price: Double {
        switch self {
        case .monthly: return 9.99
        case .yearly: return 49.99
        }
    }
}

#Preview("Premium View") {
    NavigationStack {
        PremiumView()
    }
    .preferredColorScheme(.dark)
}