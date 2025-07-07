//
//  HomeView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 03/07/2025.
//

import SwiftUI


import SwiftUI

struct HomeView: View {
    // MARK: – State
    @State private var searchText = ""
    @State private var articles: [String] = []
    @State private var videos: [String] = []
    @State private var exercises: [String] = []
    @State private var music: [String] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var userName: String = "Guest"
    @State private var selectedMood: Mood = .relaxed  // Default mood is relaxed

    // Mood options and their associated colors and icons
    enum Mood: String, CaseIterable {
        case energized = "Energized"
        case relaxed = "Relaxed"
        case anxious = "Anxious"
        case sad = "Sad"
        
        var color: Color {
            switch self {
            case .energized: return Color.green
            case .relaxed: return Color.blue
            case .anxious: return Color.orange
            case .sad: return Color.purple
            }
        }

        var icon: String {
            switch self {
            case .energized: return "flame.fill"
            case .relaxed: return "leaf.fill"
            case .anxious: return "exclamationmark.triangle.fill"
            case .sad: return "cloud.rain.fill"
            }
        }
    }

    // Example content data (articles, videos, music, exercises)
    private let articlesData = [
        ("Managing Stress", "lightbulb.fill"),
        ("Mindfulness Techniques", "circle.fill"),
        ("How to Relax", "megaphone.fill")
    ]
    
    private let videosData = [
        ("Breathing Exercises", "play.fill"),
        ("Guided Meditation", "tv.fill"),
        ("Positive Affirmations", "speaker.wave.2.fill")
    ]
    
    private let exercisesData = [
        ("Deep Breathing", "bolt.fill"),
        ("Stretching Exercises", "figure.walk"),
        ("Progressive Muscle Relaxation", "person.3.fill")
    ]
    
    private let musicData = [
        ("Calm Piano Music", "music.note"),
        ("Nature Sounds", "waveform.path.ecg"),
        ("Binaural Beats", "ear")
    ]

    // MARK: – Computed Properties
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:   return "Good Morning"
        case 12..<17:  return "Good Afternoon"
        default:       return "Good Evening"
        }
    }

    // MARK: – Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting + User Name
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(greeting),")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text(userName)
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .onAppear(perform: fetchUserName)

                    // Mood Picker
                    Picker("Select Mood", selection: $selectedMood) {
                        ForEach(Mood.allCases, id: \.self) { mood in
                            Text(mood.rawValue)
                                .foregroundColor(mood.color)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)

                    // Search Bar (optional search for content)
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search for content...", text: $searchText)
                            .foregroundColor(.black)
                            .onSubmit { fetchTherapyContent(query: searchText) }
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(15)

                    // Loading Indicator
                    if isLoading {
                        ProgressView("Loading content...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }

                    // Error Message
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }

                    // Articles Section
                    Text("Articles")
                        .font(.headline)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(articlesData, id: \.0) { article, icon in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(selectedMood.color.opacity(0.1)) // Color code based on selected mood
                                            .frame(width: 200, height: 180)
                                        VStack {
                                            ZStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [selectedMood.color, selectedMood.color.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50)
                                                Image(systemName: icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.white)
                                            }
                                            Text(article)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                        }
                                    }
                                    .shadow(radius: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Videos Section
                    Text("Videos")
                        .font(.headline)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(videosData, id: \.0) { video, icon in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(selectedMood.color.opacity(0.1)) // Color code based on selected mood
                                            .frame(width: 200, height: 180)
                                        VStack {
                                            ZStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [selectedMood.color, selectedMood.color.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50)
                                                Image(systemName: icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.white)
                                            }
                                            Text(video)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                        }
                                    }
                                    .shadow(radius: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Exercises Section
                    Text("Exercises")
                        .font(.headline)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(exercisesData, id: \.0) { exercise, icon in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(selectedMood.color.opacity(0.1)) // Color code based on selected mood
                                            .frame(width: 200, height: 180)
                                        VStack {
                                            ZStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [selectedMood.color, selectedMood.color.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50)
                                                Image(systemName: icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.white)
                                            }
                                            Text(exercise)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                        }
                                    }
                                    .shadow(radius: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Music Section
                    Text("Music")
                        .font(.headline)
                        .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(musicData, id: \.0) { song, icon in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(selectedMood.color.opacity(0.1)) // Color code based on selected mood
                                            .frame(width: 200, height: 180)
                                        VStack {
                                            ZStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [selectedMood.color, selectedMood.color.opacity(0.8)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                .clipShape(Circle())
                                                .frame(width: 50, height: 50)
                                                Image(systemName: icon)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30, height: 30)
                                                    .foregroundColor(.white)
                                            }
                                            Text(song)
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .padding()
                                        }
                                    }
                                    .shadow(radius: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "#141A20"),
                        Color(hex: "#212A34")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        .navigationBarHidden(true)
    }

    // MARK: – Methods

    private func fetchUserName() {
        userName = "Guest" // Replace with user fetching logic if necessary
    }

    private func fetchTherapyContent(query: String) {
        // Placeholder function for fetching content based on search query
        // Implement API or local fetching logic
        print("Searching for: \(query)")
    }
}



#Preview {
    HomeView()
}
