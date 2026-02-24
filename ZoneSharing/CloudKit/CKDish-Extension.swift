//
//  CKDish-Extension.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import Foundation
import CloudKit

public extension CKDish {
    internal var genericID: String {
        return self.recordID.recordName
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    func require<T>(_ key: String) throws -> T {
        guard let value = self[key] as? T else { throw InvalidDish(self) }
        
        return value
    }
}

internal struct InvalidDish: LocalizedError {
    let dish: CKDish
    
    init(_ dish: CKDish) {
        self.dish = dish
    }

    /// A localized message describing what error occurred.
    var errorDescription: String? {
        "Invalid dish '\(dish.recordType)' (\(dish.genericID))"
    }
    
    /// A localized message describing the reason for the failure.
    var failureReason: String? { "Mismatching types" }

    /// A localized message describing how one might recover from the failure.
    var recoverySuggestion: String? { "Match your types" }

    /// A localized message providing "help" text if the user requests help.
    var helpAnchor: String? { "The CloudKit Dish is missing a valid field" }
}
