//
//  ContentView.swift
//  Whisper
//
//  Created by Fatmasarah Abdikadir on 02/07/2025.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

enum Tab: Hashable {
    case home, interface, analytics, profile
}


struct ContentView: View {
    @State private var isSignedIn = false
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        if isSignedIn {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tab.home)

                InterfaceView()
                    .tabItem {
                        Label("Interface", systemImage: "fan")
                    }
                    .tag(Tab.interface)

                AnalyticsView()
                    .tabItem {
                        Label("Analytics", systemImage: "chart.pie")
                    }
                    .tag(Tab.analytics)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                    .tag(Tab.profile)
            }
            .tint(.orange)
        } else {
            SignUp(isSignedIn: $isSignedIn, selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
}
