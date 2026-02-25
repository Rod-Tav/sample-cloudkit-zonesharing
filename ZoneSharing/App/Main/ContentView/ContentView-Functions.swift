//
//  ContentView-Functions.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

extension ContentView {
    internal func addContact(name: String, phoneNumber: String, group: String) async throws {
        try await vm.addContact(name: name, phoneNumber: phoneNumber, group: group)
        try await vm.refresh()
        isAddingContact = false
    }
    
    internal func shareGroup(_ contactGroup: ContactGroup) async throws {
        isProcessingShare = true

        do {
            let (share, container) = try await vm.fetchOrCreateShare(contactGroup: contactGroup)
            isProcessingShare = false
            activeShare = share
            activeContainer = container
            isSharing = true
        } catch {
            debugPrint("Error sharing contact record: \(error)")
        }
    }
}
