//
//  CKAirport.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit

public typealias CKAirport = CKRecord

public extension CKAirport {
    internal var genericID: String {
        return self.recordID.recordName
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    func require<T>(_ key: String) throws -> T {
        guard let value = self[key] as? T else { throw InvalidAirport(self) }
        
        return value
    }
    
    internal struct InvalidAirport: LocalizedError {
        let airport: CKAirport
        
        init(_ airport: CKAirport) {
            self.airport = airport
        }

        /// A localized message describing what error occurred.
        var errorDescription: String? {
            "Invalid airport '\(airport.recordType)' (\(airport.genericID))"
        }
        
        /// A localized message describing the reason for the failure.
        var failureReason: String? { "The airport contains mismatching types" }

        /// A localized message describing how one might recover from the failure.
        var recoverySuggestion: String? { "Ensure the airport types match" }

        /// A localized message providing "help" text if the user requests help.
        var helpAnchor: String? { "The airport is missing a valid field" }
    }
}
