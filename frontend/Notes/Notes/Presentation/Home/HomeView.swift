//
//  ContentView.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeVM = HomeViewModel()
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if homeVM.isLoading {
                    ProgressView()
                }
                else if let error = homeVM.error {
                    VStack {
                        Text(error)
                            .foregroundStyle(Color.red)
                        
                        Button("Retry") {
                            Task { await homeVM.fetchNotes() }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                else {
                    List(homeVM.notes) { note in
                        Text(note.note)
                    }
                    .refreshable {
                        await homeVM.fetchNotes()
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationDestination(for: NavigationDestinations.self) { destination in
                destination.scene
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        path.append(NavigationDestinations.addNote({
                            Task {
                                await homeVM.fetchNotes()
                            }
                        }))
                    }
                }
            }
        }
        .task {
            await homeVM.fetchNotes()
        }
    }
}

#Preview {
    HomeView()
}
