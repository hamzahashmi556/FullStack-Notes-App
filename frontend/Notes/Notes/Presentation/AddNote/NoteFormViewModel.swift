//
//  AddNoteViewModel.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation
import Combine

final class NoteFormViewModel: ObservableObject {
    
    @Published var text: String
    
    @Published private(set) var error: String? = nil
    
    @Published private(set) var isLoading = false
    
    private(set) var selectedNoteId: String?
    
    init(note: Note?) {
        self.text = note?.note ?? ""
        self.selectedNoteId = note?.id
    }
    
    func post(success: @escaping () -> Void) {
        Task {
            self.isLoading = true
            defer {
                self.isLoading = false
            }
            do {
                let service = NotesService()
                if let selectedNoteId {
                    let note = try await service.update(noteID: selectedNoteId, text: text)
                    print("Note Updated: \(dump(note))")
                }
                else {
                    try await service.createNote(note: text)
                }
                success()
            }
            catch {
                self.error = error.localizedDescription
            }
        }
    }
}
