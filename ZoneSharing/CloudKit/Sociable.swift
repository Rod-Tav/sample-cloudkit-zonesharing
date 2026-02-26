//
//  Securable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/25/26.
//

import Foundation

protocol Sociable: Identifiable, Sendable {
    /// The type of items being paginated (e.g., User, FeedItem, Comment)
    associatedtype Item: Identifiable
    
    var airplane: Airplane<Item> { get set }
    var terminal: CKTerminal { get set }
    
    func tripID() -> String?
    func trip(from terminal: CKTerminal) -> CKFlight?
}

extension Sociable {
    func tripID(from terminal: CKTerminal) -> Airplane<Item> {
        return Airplane(zone: trip(from: terminal)?.zoneID.zoneName)
    }
    
    func trip(from terminal: CKTerminal) -> CKFlight? {
        return CKFlight(zoneID: terminal.gate)
    }
}
