//
//  AddNoteViewModel.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation
import Combine

final class AddNoteViewModel: ObservableObject {
    
    @Published
    var text = ""
    
    @Published
    private(set) var error: String? = nil
    
    @Published
    private(set) var isLoading = false
    
    func post(success: @escaping () -> Void) {
        Task {
            self.isLoading = true
            defer {
                self.isLoading = false
            }
            do {
                let service = NotesService()
                try await service.createNote(note: text)
                success()
            }
            catch {
                self.error = error.localizedDescription
            }
        }
    }
}
