//
//  ObservablePassengers.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

@Observable @MainActor public final class ObservablePassengers {
    var names: [CKRecord.ID: String] = [:]
    
    func name(for passenger: CKPassenger) -> String {
        names[passenger.recordID] ?? passenger.recordType
    }
    
    func setName(_ name: String, for passenger: CKPassenger) {
        names[passenger.recordID] = name
    }
}
