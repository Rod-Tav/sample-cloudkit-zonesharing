//
//  ContentView.swift
//  (cloudkit-samples) Zone Sharing
//

import SwiftUI
import CloudKit

struct ContentView: View {

    // MARK: - Properties & State

    @State internal var vm = ViewModel()

    @State internal var isAddingContact = false
    @State internal var isSharing = false
    @State internal var isProcessingShare = false

    @State internal var activeShare: CKShare?
    @State internal var activeContainer: CKContainer?
    
    internal var showProgress: Bool {
        if case .loading = vm.state {
            return true
        } else if isProcessingShare {
            return true
        }

        return false
    }

    // MARK: - Views

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Contacts")
                .toolbar {
                    refreshButton
                    
                    progressView
                    
                    addContactButton
                }
        }
        .sheet(isPresented: $isAddingContact) {
            AddContactView(
                onAdd: addContact,
                onCancel: { isAddingContact = false }
            )
        }
        .sheet(isPresented: $isSharing) {
            shareView()
        }
    }

    /// Builds a `CloudSharingView` with state after processing a share.
    private func shareView() -> CloudSharingView? {
        guard let share = activeShare, let container = activeContainer else {
            return nil
        }

        return CloudSharingView(container: container, share: share)
    }
}

// MARK: - Content
private extension ContentView {
    /// Dynamic view built from ViewModel state.
    var contentView: some View {
        Group {
            switch vm.state {
            case let .loaded(privateContacts, sharedContacts):
                loadedContent(privateContacts, sharedContacts)

            case .error(let error):
                errorContent(error)

            case .loading:
                loadingContent
            }
        }
    }
    
    // MARK: Loaded Content
    func loadedContent(_ privateContacts: [ContactGroup], _ sharedContacts: [ContactGroup]) -> some View {
        List {
            ForEach(privateContacts) { contactGroup in
                Section {
                    ForEach(contactGroup.contacts) { contactRowView(for: $0) }
                } header: {
                    Text("Private Group: \(contactGroup.name)")
                } footer: {
                    Button("Share Group") { Task { try? await shareGroup(contactGroup) } }
                }
            }
            
            ForEach(sharedContacts) { contactGroup in
                Section {
                    ForEach(contactGroup.contacts) { contactRowView(for: $0) }
                } header: {
                    Text("Shared Group: \(contactGroup.name)")
                }
            }
        }.listStyle(GroupedListStyle())
    }
    
    /// Builds a Contact row view for display contact information in a List.
    func contactRowView(for contact: Contact) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(contact.name)
                
                Text(contact.phoneNumber)
                    .textContentType(.telephoneNumber)
                    .font(.footnote)
            }
        }
    }
    
    // MARK: Error Content
    func errorContent(_ error: Error) -> some View {
        VStack {
            Text("An error occurred: \(error.localizedDescription)").padding()
        }
        .maxHeight(spacer: .bottom)
    }
    
    // MARK: Loading Content
    var loadingContent: some View  {
        VStack { EmptyView() }
    }
}

// MARK: - Toolbar
private extension ContentView {
    @ToolbarContentBuilder var refreshButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                Task { try await vm.refresh() }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    
    /// This progress view will display when either the ViewModel is loading, or a share is processing.
    @ToolbarContentBuilder var progressView: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if showProgress {
                ProgressView()
            }
        }
    }
    
    @ToolbarContentBuilder var addContactButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isAddingContact = true
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var previewContacts = ContactGroup(
        zone: SecureSocialData(zoneName: "Preview Group"),
        contacts:
            [
                Contact(
                    id: UUID().uuidString,
                    name: "John Appleseed",
                    phoneNumber: "(888) 555-5512",
                    associatedStation: SecureData(recordType: "SharedContact")
                )
            ]
    )
    
    ContentView()
        .environment(ViewModel(state: .loaded(privateGroups: [previewContacts], sharedGroups: [previewContacts])))
}
