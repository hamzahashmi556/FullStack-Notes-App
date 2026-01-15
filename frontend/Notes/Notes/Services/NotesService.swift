//
//  NotesService.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation

final class NotesService {
    
    let baseURL = "http://192.168.18.254:3000/notes"
    
    enum HTTPMethod: String {
        case GET, POST, PATCH, DELETE
    }
    
    private func createURLRequest(
        method: HTTPMethod,
        urlEndpoint: String? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 60.0,
        requestBody: Codable? = nil
    ) throws -> URLRequest {
        guard var url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        if let urlEndpoint {
             url = url.appending(path: "/" + urlEndpoint)
        }
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
        if let requestBody {
            request.httpBody = try JSONEncoder().encode(requestBody)
        }
        return request
    }
    
    func createNote(note: String) async throws {
        
        let requestBody = NoteRequest(note: note)
        
        let request = try createURLRequest(method: .POST, requestBody: requestBody)
        
        do {
            _ = try await URLSession.shared.data(for: request)
        }
        catch {
            print("Create Note Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getNotes() async throws -> [Note] {
        let request = try createURLRequest(method: .GET)
        let (data, _) = try await URLSession.shared.data(for: request)
        let notes = try JSONDecoder().decode([Note].self, from: data)
        return notes
    }
    
    func delete(noteID: String) async throws -> String? {
        let request = try createURLRequest(method: .DELETE, urlEndpoint: noteID)
        let (data, _) = try await URLSession.shared.data(for: request)
        let message = String(data: data, encoding: .utf8)
        return message
    }
    
    func update(noteID: String, text: String) async throws -> Note {
        
        let requestBody = NoteRequest(note: text)
        
        let request = try createURLRequest(method: .PATCH, urlEndpoint: noteID, requestBody: requestBody)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let note = try JSONDecoder().decode(Note.self, from: data)
        
        return note
    }
}
