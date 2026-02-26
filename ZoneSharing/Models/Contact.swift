//
//  Contact.swift
//  (cloudkit-samples) Zone Sharing
//

import Foundation
import CloudKit

/// A contact
struct Contact: Identifiable, Sociable {
    let id: String
    let name: String
    let phoneNumber: String
    
    var airplane = Airplane(zone: <#T##CKFlight#>, passengers: <#T##[Identifiable]#>)
}
