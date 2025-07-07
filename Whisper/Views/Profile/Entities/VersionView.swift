//
//  VersionView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 03/07/2025.
//

import SwiftUI

struct VersionView: View {
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    private let environment = "Development" // Change as needed (e.g., "Staging", "Development")

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("App Version Info")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)

                GlassTileView(icon: "number.circle.fill", title: "Version", subtitle: appVersion)
                GlassTileView(icon: "hammer.circle.fill", title: "Build", subtitle: buildNumber)
                GlassTileView(icon: "network", title: "Environment", subtitle: environment)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack (spacing: 10){
                    Spacer(minLength: 50) // Space above "Account"
                    Text("Version")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Spacer(minLength: 20) // Space below "Account"
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        VersionView()
    }
}




struct GlassTileView: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
