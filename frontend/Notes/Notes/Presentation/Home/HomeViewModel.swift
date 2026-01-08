//
//  NotesViewModel.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published
    private(set) var error: String? = nil
    
    @Published
    private(set) var isLoading = true
    
    @Published
    private(set) var notes: [Note] = []
    
    init() {
        
    }
    
    func fetchNotes() async {
        
        let service = NotesService()
        
        isLoading = true
        error = nil
        defer {
            isLoading = false
        }
        
        do {
            self.notes = try await service.getNotes()
        }
        catch {
            print(#function, error)
            self.error = error.localizedDescription
        }
    }
    
    func delete(noteID: String) async -> String {
        let service = NotesService()
        let message: String
        do {
            if let response = try await service.delete(noteID: noteID) {
                message = response
            }
            else {
                message = "Note Deleted"
            }
            if let index = self.notes.firstIndex(where: { $0.id == noteID }) {
                self.notes.remove(at: index)
            }
        }
        catch {
            print(#function, error)
            message = "Error Deleting Note, Reason: \(error.localizedDescription)"
        }
        return message
    }
}
