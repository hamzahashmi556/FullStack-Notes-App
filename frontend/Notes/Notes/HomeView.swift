//
//  ContentView.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import SwiftUI

struct HomeView: View {
    
    @State private var notes: [Note] = []
    @State private var error: String? = nil
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                }
                else if let error = error {
                    VStack {
                    Text(error)
                        .foregroundStyle(Color.red)
                    
                        Button("Retry") {
                            Task { await fetchNotes() }
                        }
                        .buttonStyle(.borderless)
                    }
                }
                else {
                    List(notes) { note in
                        Text(note.note)
                    }
                }
            }
            .navigationTitle("Notes")
        }
        .task {
            await fetchNotes()
        }
    }
    
    enum Endpoints: String {
        case getNotes = "/notes"
    }
    
    func fetchNotes(endPoint: Endpoints = .getNotes) async {
        isLoading = true
        error = nil
        defer {
            isLoading = false
        }
        
        let baseURL = "http://192.168.18.238:3000"
        
        guard let url = URL(string: baseURL + endPoint.rawValue) else {
            self.error = "URL is incorrect"
            return
        }
        
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoder = JSONDecoder()
            let notes = try decoder.decode([Note].self, from: data)
            self.notes = notes
        }
        catch {
            print(#function, error)
            self.error = error.localizedDescription
        }
    }
}

struct Note: Codable, Identifiable {
    var id: String
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case note
    }
}

#Preview {
    HomeView()
}
