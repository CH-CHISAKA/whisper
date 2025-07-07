//
//  InterfaceView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 03/07/2025.
//

import SwiftUI

// Mood enum for mood selection
enum Mood: String, CaseIterable {
    case energized = "Energized"
    case relaxed = "Relaxed"
    case anxious = "Anxious"
    case sad = "Sad"
}

// Music API enum
enum MusicAPI: String, CaseIterable {
    case spotify = "Spotify"
    case appleMusic = "Apple Music"
}

// Music content structure (simulated)
struct MusicContent {
    let title: String
    let artist: String
    let genre: String
    let isFiltered: Bool // Will be used for filtered content
}

// Interface View
struct InterfaceView: View {
    @State private var selectedAPI: MusicAPI = .spotify
    @State private var selectedMood: Mood = .energized
    @State private var availableMusic: [MusicContent] = []
    @State private var filteredMusic: [MusicContent] = []
    @State private var showNotification = false
    @State private var notificationMessage = "Some content is being filtered due to your current mood."
    @State private var notificationOpacity: Double = 0.0

    // Simulated music content based on mood and selected API
    func loadMusicContent() {
        // Simulating music content based on the selected API
        if selectedAPI == .spotify {
            availableMusic = [
                MusicContent(title: "Energetic Beats", artist: "DJ Alpha", genre: "Electronic", isFiltered: false),
                MusicContent(title: "Relaxing Tunes", artist: "Calm Vibes", genre: "Chill", isFiltered: false),
                MusicContent(title: "Heavy Metal Anthem", artist: "Rocker X", genre: "Rock", isFiltered: true), // Filtered for anxious/sad
                MusicContent(title: "Meditation Sounds", artist: "Zen Masters", genre: "Meditation", isFiltered: true) // Filtered for anxious/sad
            ]
        } else {
            availableMusic = [
                MusicContent(title: "Pop Hits", artist: "Pop Star", genre: "Pop", isFiltered: false),
                MusicContent(title: "Classical Music", artist: "Beethoven", genre: "Classical", isFiltered: false),
                MusicContent(title: "Heavy Rock", artist: "Rock Legends", genre: "Rock", isFiltered: true), // Filtered for anxious/sad
                MusicContent(title: "Relaxation Soundscapes", artist: "Nature Sounds", genre: "Ambient", isFiltered: true) // Filtered for anxious/sad
            ]
        }
        
        // Apply filtering based on mood
        filteredMusic = availableMusic.filter { content in
            switch selectedMood {
            case .energized, .relaxed:
                return true // No filtering for these moods
            case .anxious, .sad:
                if content.isFiltered {
                    showNotification = true
                    withAnimation {
                        notificationOpacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            notificationOpacity = 0.0
                        }
                    }
                }
                return !content.isFiltered // Filtered for anxious/sad
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: – Music Player Title (Centered)
                Text("Music Player")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity)
                    .background(getMoodGradientForEntities(selectedMood))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .offset(y: 30)

                // MARK: – Mood Selector
                Picker("Select your Mood", selection: $selectedMood) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Text(mood.rawValue)
                            .foregroundColor(getMoodColor(mood))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .offset(y: 50)

                // MARK: – API Selector
                Picker("Select Music Service", selection: $selectedAPI) {
                    ForEach(MusicAPI.allCases, id: \.self) { api in
                        Text(api.rawValue)
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .offset(y: 50)

                // MARK: – Load Music Content Button
                Button(action: {
                    loadMusicContent()
                }) {
                    Text("Load Music Content")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(getMoodGradientForEntities(selectedMood))
                        .cornerRadius(10)
                }
                .padding()
                .offset(y: 70)

                // MARK: – Notification Banner (Only for Anxious and Sad Moods)
                if showNotification {
                    Text(notificationMessage)
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .opacity(notificationOpacity)
                }
                
                // MARK: – Simulated Music Canvas (Filtered Music List)
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredMusic, id: \.title) { content in
                            HStack {
                                Text(content.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text(content.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(getMoodGradientForEntities(selectedMood).opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .offset(y: 60)
                }

                Spacer()
            }
            // MARK: – Background Gradient (Constant for all moods)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
            .onChange(of: selectedAPI) { _ in
                loadMusicContent() // Reload content when API changes
            }
            .onChange(of: selectedMood) { _ in
                loadMusicContent() // Reload content when mood changes
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline) // Ensures centered title
        }
    }

    // MARK: – Get Color for Each Mood
    private func getMoodColor(_ mood: Mood) -> Color {
        switch mood {
        case .energized:
            return Color.green
        case .relaxed:
            return Color.blue
        case .anxious:
            return Color.orange
        case .sad:
            return Color.purple
        }
    }

    // MARK: – Get Gradient for Entities Based on Mood
    private func getMoodGradientForEntities(_ mood: Mood) -> LinearGradient {
        switch mood {
        case .energized:
            return LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .top, endPoint: .bottom)
        case .relaxed:
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
        case .anxious:
            return LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom)
        case .sad:
            return LinearGradient(gradient: Gradient(colors: [Color.purple, Color.black]), startPoint: .top, endPoint: .bottom)
        }
    }
}

#Preview {
    InterfaceView()
}
