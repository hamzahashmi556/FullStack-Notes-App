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
    
    @State private var showAlert = false
    
    @State private var message = ""
    
    @State private var selectedNoteId: String? = nil
    
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
                        
                        Button {
                            path.append(NavigationDestinations.noteForm(note: note, noteAdded: refresh))
                        } label: {
                            Text(note.note)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button("Delete", role: .destructive) {
                                selectedNoteId = note.id
                                showAlert = true
                                message = "Confirm Delete note?"
                            }
                        })
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
                        path.append(NavigationDestinations.noteForm(note: nil, noteAdded: refresh))
                    }
                }
            }
        }
        .task {
            await homeVM.fetchNotes()
        }
        .alert("Alert", isPresented: $showAlert, actions: {
            if let selectedNoteId {
                Button("Delete", role: .destructive) {
                    delete(noteId: selectedNoteId)
                }
            }
        }, message: {
            Text(message)
        })
    }
    
    func refresh() {
        Task {
            await homeVM.fetchNotes()
        }
    }
    
    func delete(noteId: String) {
        Task {
            _ = await homeVM.delete(noteID: noteId)
        }
    }
}

#Preview {
    HomeView()
}
