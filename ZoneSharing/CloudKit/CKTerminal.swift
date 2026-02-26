//
//  CKTerminal.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit

public typealias CKTerminal = CKRecord

public extension CKTerminal {
    var name: String { self.recordID.zoneID.zoneName }
    var gate: CKRecordZone.ID { self.recordID.zoneID }
}

public extension CKTerminal {
    internal var genericID: String {
        return self.recordID.recordName
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    func require<T>(_ key: String) throws -> T {
        guard let value = self[key] as? T else { throw InvalidTerminal(self) }
        
        return value
    }
    
    internal struct InvalidTerminal: LocalizedError {
        let terminal: CKTerminal
        
        init(_ terminal: CKTerminal) {
            self.terminal = terminal
        }

        /// A localized message describing what error occurred.
        var errorDescription: String? {
            "Invalid station '\(terminal.recordType)' (\(terminal.genericID))"
        }
        
        /// A localized message describing the reason for the failure.
        var failureReason: String? { "The terminal contains mismatching types" }

        /// A localized message describing how one might recover from the failure.
        var recoverySuggestion: String? { "Ensure the terminal types match" }

        /// A localized message providing "help" text if the user requests help.
        var helpAnchor: String? { "The terminal is missing a valid field" }
    }
}
