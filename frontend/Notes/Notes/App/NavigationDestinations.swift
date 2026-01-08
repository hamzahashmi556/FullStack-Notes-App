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
        case .addNote(_):
            return "addNote"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case addNote(() -> Void)
    
    var scene: some View {
        switch self {
        case .addNote(let addedNote):
            AddNoteView(addedNote: addedNote)
        }
    }
}
