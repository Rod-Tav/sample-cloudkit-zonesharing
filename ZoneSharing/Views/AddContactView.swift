//
//  AddContactView.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import SwiftUI

/// View for adding new contacts.
struct AddContactView: View {
    @State private var nameInput: String = ""
    @State private var phoneInput: String = ""
    @State private var groupInput: String = ""

    /// What to do after user selects to add contact with given name and phone number.
    var onAdd: (String, String, String) async throws -> Void = { _,_,_ in }
    /// What to do after user cancels.
    var onCancel: () -> Void = { }

    var body: some View {
        NavigationStack {
            addContactContent
        }
    }
    
    @ViewBuilder private var addContactContent: some View {
        VStack {
            TextField("Full Name", text: $nameInput)
                .textContentType(.name)
            
            TextField("Phone Number", text: $phoneInput)
                .textContentType(.telephoneNumber)
            
            TextField("Group", text: $groupInput)
        }
        .padding()
        .maxHeight(spacer: .bottom)
        .navigationTitle("Add Contact")
        .toolbar {
            cancellationToolbarContent
            
            confirmationToolbarContent
        }
    }
}

// MARK: - Toolbar
extension AddContactView {
    @ToolbarContentBuilder private var cancellationToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", action: onCancel)
        }
    }
    
    @ToolbarContentBuilder private var confirmationToolbarContent: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                Task {
                    try? await onAdd(nameInput, phoneInput, groupInput)
                }
            }
            .disabled(canSave)
        }
    }
}

// MARK: - Functions
private extension AddContactView {
    var canSave: Bool {
        nameInput.isEmpty || phoneInput.isEmpty || groupInput.isEmpty
    }
}
