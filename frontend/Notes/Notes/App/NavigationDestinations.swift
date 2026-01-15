//
//  NavigationDestinations.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import SwiftUI

enum NavigationDestinations: Hashable, Equatable {
    
    
    static func == (lhs: NavigationDestinations, rhs: NavigationDestinations) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .noteForm(note: _, noteAdded: _):
            return "noteForm"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case noteForm(note: Note?, noteAdded: () -> Void)
    
    var scene: some View {
        switch self {
        case .noteForm(note: let note, noteAdded: let noteAdded):
            NoteFormView(note: note, addedNote: noteAdded)
        }
    }
}
