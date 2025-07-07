//
//  ProfileView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 03/07/2025.
//

import SwiftUI

// MARK: – Profile View
struct ProfileView: View {
    @State private var showSignOutAnimation    = false
    @State private var showDeleteAnimation     = false
    @State private var navigateToLogin         = false
    @State private var navigateToSignUp        = false

    // Separate state for error alert
    @State private var showProfileError = false
    @State private var profileErrorMsg  = ""

    // Placeholder values
    private let fullName = "Guest User"
    private let email    = "guest@example.com"
    private let initials = "G"

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                List {
                    // MARK: – Profile Header
                    Section {
                        HStack(spacing: 12) {
                            Text(initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 55, height: 55)
                                .background(Color(.systemGray))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // MARK: – Main Menu
                    Section("Main Menu") {
                        NavigationLink(destination: AccountsView()) {
                            ProfileRow(icon: "key.fill", title: "Account")
                        }
                        NavigationLink(destination: AnalyticsView()) {
                            ProfileRow(icon: "chart.pie", title: "Analytics")
                        }
                        NavigationLink(destination: ProductsView()) {
                            ProfileRow(icon: "archivebox.fill", title: "Products")
                        }
                        NavigationLink(destination: ScheduleView()) {
                            ProfileRow(icon: "person.2.fill", title: "Schedule")
                        }
                    }

                    // MARK: – Settings
                    Section("Settings") {
                        NavigationLink(destination: SettingsView()) {
                            ProfileRow(icon: "gearshape.fill", title: "Settings")
                        }
                        NavigationLink(destination: VersionView()) {
                            ProfileRow(icon: "gear", title: "Version")
                        }
                    }

                    // MARK: – Sign Out / Delete
                    Section {
                        Button(action: signOut) {
                            ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", tint: .blue)
                        }
                        .alert("Signing Out", isPresented: $showSignOutAnimation) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("You have successfully signed out.")
                        }

                        Button(action: deleteAccount) {
                            ProfileRow(icon: "trash", title: "Delete Account", tint: .red)
                        }
                        .alert("Deleting Account", isPresented: $showDeleteAnimation) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Your account has been deleted.")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarHidden(true)
            // MARK: – Navigation to Login / SignUp
            .fullScreenCover(isPresented: $navigateToLogin) {
                LogIn()
            }
            .fullScreenCover(isPresented: $navigateToSignUp) {
                SignUp(
                    isSignedIn: .constant(false),
                    selectedTab: .constant(.home) // or whatever default tab makes sense
                )
            }
        }
    }

    // MARK: – Sign Out Logic
    private func signOut() {
        showSignOutAnimation = true
        // e.g. clear user session / cached data here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            navigateToLogin = true
        }
    }

    // MARK: – Delete Account Logic
    private func deleteAccount() {
        showDeleteAnimation = true
        // e.g. remove local user data here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            navigateToSignUp = true
        }
    }
}

// MARK: – Helper Row View
struct ProfileRow: View {
    let icon: String
    let title: String
    var tint: Color = .white

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(tint)
                .frame(width: 32, height: 32)
            Text(title)
                .font(.subheadline)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileView()
}
