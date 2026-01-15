//
//  AddNoteView.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import SwiftUI

struct NoteFormView: View {
    
    @StateObject private var vm: NoteFormViewModel
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    let addedNote: () -> Void
    
    init(note: Note?, addedNote: @escaping () -> Void) {
        self._vm = StateObject(wrappedValue: NoteFormViewModel(note: note))
        self.addedNote = addedNote
    }
    
    var body: some View {
        VStack {
            TextField("Enter Note", text: $vm.text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .padding()
                .clipped()
                .onAppear {
                    isFocused = true
                }
            
            Button {
                vm.post(success: {
                    dismiss()
                    addedNote()
                })
            } label: {
                if vm.isLoading {
                    ProgressView()
                }
                else {
                    Text(vm.selectedNoteId == nil ? "Add" : "Update")
                }
            }
            .buttonStyle(.bordered)
            
            if let error = vm.error {
                Text(error)
                    .foregroundStyle(Color.red)
            }
        }
        .onTapGesture {
            isFocused = false
        }
    }
}
