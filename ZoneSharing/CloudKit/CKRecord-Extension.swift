//
//  CKRecord-Extension.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import Foundation
import CloudKit

extension CKRecord {
    internal var genericID: String {
        return self.recordID.recordName
    }

    /// Extracts a required field value, throwing if the key is missing or the type doesn't match.
    public func require<T>(_ key: String) throws -> T {
        guard let value = self[key] as? T else {
            throw AppError(record: self)
        }
        
        return value
    }
}

struct AppError: LocalizedError {
    let record: CKRecord

    var errorDescription: String? {
        "Invalid record '\(record.recordType)' (\(record.genericID))"
    }
}
