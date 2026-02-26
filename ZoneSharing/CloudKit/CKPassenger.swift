//
//  CKPassenger.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public typealias CKPassenger = CKRecord

public extension CKPassenger {
    convenience init(ticket: String) {
        self.init(recordType: ticket)
    }
}
