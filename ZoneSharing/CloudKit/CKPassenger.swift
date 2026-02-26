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
    func getName() -> String {
        return self.recordType
    }
    
    convenience init(name: String) {
        self.init(recordType: name)
    }
}
