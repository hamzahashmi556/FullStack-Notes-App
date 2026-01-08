//
//  NotesService.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation

final class NotesService {
    
    let baseURL = "http://192.168.18.238:3000"

    enum Endpoints: String {
        case notes = "/notes"
    }
    
    func createNote(note: String) async throws {
        
        let requestBody = NoteRequest(note: note)
        
        let endPoint = Endpoints.notes.rawValue
        
        guard let url = URL(string: baseURL + endPoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            _ = try await URLSession.shared.data(for: request)
        }
        catch {
            print("Create Note Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getNotes() async throws -> [Note] {
        
        let endPoint = Endpoints.notes.rawValue
        
        guard let url = URL(string: baseURL + endPoint) else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let notes = try decoder.decode([Note].self, from: data)
        return notes
    }
}
