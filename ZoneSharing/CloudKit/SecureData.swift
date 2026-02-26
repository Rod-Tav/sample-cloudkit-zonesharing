//
//  SecureData.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit

public typealias SecureData = CKRecord
public typealias SecureSocialGroup = CKRecordZone

public extension SecureData {
    internal var genericID: String {
        return self.recordID.recordName
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    func require<T>(_ key: String) throws -> T {
        guard let value = self[key] as? T else { throw InvalidStation(self) }
        
        return value
    }
    
    internal struct InvalidStation: LocalizedError {
        let station: SecureData
        
        init(_ station: SecureData) {
            self.station = station
        }

        /// A localized message describing what error occurred.
        var errorDescription: String? {
            "Invalid station '\(station.recordType)' (\(station.genericID))"
        }
        
        /// A localized message describing the reason for the failure.
        var failureReason: String? { "Mismatching types" }

        /// A localized message describing how one might recover from the failure.
        var recoverySuggestion: String? { "Match your types" }

        /// A localized message providing "help" text if the user requests help.
        var helpAnchor: String? { "The CloudKit Station is missing a valid field" }
    }
}
