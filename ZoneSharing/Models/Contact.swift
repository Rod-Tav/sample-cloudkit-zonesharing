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
    let frequentedStation: CKStation

    // MARK: - Sociable

    func getSocialID() -> String? {
        return frequentedStation.name
    }

    func getSyncedData() -> CKStation? {
        frequentedStation
    }

    func getCKNetwork() -> CKNetwork? {
        return CKNetwork(zoneID: frequentedStation.stationID)
    }
}
