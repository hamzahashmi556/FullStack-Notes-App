//
//  AddNoteView.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import SwiftUI

struct AddNoteView: View {
    
    @StateObject private var vm = AddNoteViewModel()
    
    @FocusState private var isFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    let addedNote: () -> Void
    
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
                    Text("Add")
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
