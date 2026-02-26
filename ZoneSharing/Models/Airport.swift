//
//  Airport.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

public actor Airport<T: Sociable> {
    var record: CKRecord?
    var name: String
    var ID: CKRecordZone.ID
    private(set) var airplanes: [Airplane<T>] = []
    
    init(record: CKRecord) {
        self.name = record.recordID.zoneID.zoneName
        self.ID = record.recordID.zoneID
    }
}
