//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

struct Contact: Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let associatedRecord: CKRecord
}

// MARK: - CKRecord Field Extraction

extension CKRecord {
    /// Extracts a field value from the record, returning nil if the key is missing or the type doesn't match.
    func value<T>(forKey key: String) -> T? {
        self[key] as? T
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    func requiredValue<T>(forKey key: String) throws -> T {
        guard let value: T = self[key] as? T else {
            throw CKRecordFieldError.missingOrInvalidField(key: key, expectedType: String(describing: T.self))
        }
        return value
    }
}

enum CKRecordFieldError: LocalizedError {
    case missingOrInvalidField(key: String, expectedType: String)

    var errorDescription: String? {
        switch self {
        case .missingOrInvalidField(let key, let expectedType):
            return "Missing or invalid field '\(key)' (expected \(expectedType))"
        }
    }
}

// MARK: - CKRecord Init

extension Contact {
    /// Initializes a `Contact` object from a CloudKit record.
    /// - Parameter record: CloudKit record to pull values from.
    init(record: CKRecord) throws {
        self.id = record.recordID.recordName
        self.name = try record.requiredValue(forKey: "name")
        self.phoneNumber = try record.requiredValue(forKey: "phoneNumber")
        self.associatedRecord = record
    }
}
