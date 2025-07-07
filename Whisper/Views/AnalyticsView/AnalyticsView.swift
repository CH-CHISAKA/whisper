//
//  AnalysticsView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 03/07/2025.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    // MARK: - State
    @State private var moodHistory: [MoodData] = [
        MoodData(date: Date().addingTimeInterval(-3600*24*6), mood: .energized),
        MoodData(date: Date().addingTimeInterval(-3600*24*5), mood: .relaxed),
        MoodData(date: Date().addingTimeInterval(-3600*24*4), mood: .anxious),
        MoodData(date: Date().addingTimeInterval(-3600*24*3), mood: .sad),
        MoodData(date: Date().addingTimeInterval(-3600*24*2), mood: .relaxed),
        MoodData(date: Date().addingTimeInterval(-3600*24),   mood: .energized)
    ]
    
    @State private var totalExercisesCompleted = 15
    @State private var totalArticlesRead     = 8
    @State private var totalVideosWatched    = 5
    
    // MARK: - Computed
    private var moodCount: [Mood: Int] {
        Dictionary(grouping: moodHistory, by: { $0.mood })
            .mapValues { $0.count }
    }

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: – Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#141A20"), Color(hex: "#212A34")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Header
                        Text("Analytics Overview")
                            .font(.largeTitle).bold()
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.horizontal)
                        
                        // Mood History Chart
                        Text("Mood History")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Chart {
                            ForEach(moodHistory, id: \.date) { entry in
                                LineMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Mood", entry.mood.rawValue)
                                )
                                .foregroundStyle(by: .value("Mood", entry.mood.rawValue))
                                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                                .symbol(by: .value("Mood", entry.mood.rawValue))
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisValueLabel().foregroundStyle(.white)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) {
                                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [5,5]))
                                    .foregroundStyle(Color.white.opacity(0.2))
                                AxisValueLabel().foregroundStyle(.white)
                            }
                        }
                        .frame(height: 300)
                        .padding(.horizontal)
                        
                        // Results Output Section
                        Text("User Activity Summary")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 18) {
                            HStack {
                                Text("Total Exercises Completed:")
                                    .font(.headline).foregroundColor(.white)
                                Spacer()
                                Text("\(totalExercisesCompleted)")
                                    .font(.subheadline).bold().foregroundColor(.white)
                            }
                            HStack {
                                Text("Total Articles Read:")
                                    .font(.headline).foregroundColor(.white)
                                Spacer()
                                Text("\(totalArticlesRead)")
                                    .font(.subheadline).bold().foregroundColor(.white)
                            }
                            HStack {
                                Text("Total Videos Watched:")
                                    .font(.headline).foregroundColor(.white)
                                Spacer()
                                Text("\(totalVideosWatched)")
                                    .font(.subheadline).bold().foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Mood Count Section
                        Text("Mood Selection Summary")
                            .font(.title2).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                HStack {
                                    Text("\(mood.rawValue) Selected:")
                                        .font(.headline).foregroundColor(.white)
                                    Spacer()
                                    Text("\(moodCount[mood] ?? 0)")
                                        .font(.subheadline).bold().foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer(minLength: 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Models
    struct MoodData {
        let date: Date
        let mood: Mood
    }
    enum Mood: String, CaseIterable {
        case energized = "Energized"
        case relaxed   = "Relaxed"
        case anxious   = "Anxious"
        case sad       = "Sad"
    }
}

// MARK: – Color Extension for Hex Initialization
//extension Color {
//    init(hex: String) {
//        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
//        var hexInt: UInt64 = 0
//        Scanner(string: hexSanitized).scanHexInt64(&hexInt)
//        let red   = Double((hexInt >> 16) & 0xFF) / 255.0
//        let green = Double((hexInt >> 8)  & 0xFF) / 255.0
//        let blue  = Double(hexInt         & 0xFF) / 255.0
//        self.init(red: red, green: green, blue: blue)
//    }
//}

#Preview {
    AnalyticsView()
}
