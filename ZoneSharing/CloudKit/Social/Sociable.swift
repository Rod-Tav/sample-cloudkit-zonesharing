//
//  Sociable.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import CloudKit
import Foundation
import Observation

@available(iOS 17.0, *)
@MainActor public protocol Sociable: AnyObject, Observable, Sendable, Identifiable, Hashable, Equatable {
    associatedtype Item: Socialite
   
    var state: SocialState<Item> { get set }
//    var airport: CKAirport<Item> { get set }
//    var currentPassenger: CKPassenger<Item>? { get set }
   
    func bigBang()
    func refresh() async throws
}

extension Sociable where Self: Equatable {
    func equals(lhs: any Socialite, rhs: any Socialite) -> Bool {
        lhs.passenger.getName() == rhs.passenger.getName()
    }
}

extension Sociable {
    func bigBang(at code: String) async throws {
        self.airport = CKAirport(code: CKGate.privateGate(containerIdentifier: Config.containerIdentifier))
        
        self.currentPassenger = gate.terminal.getPassengers()
       
        if let recordID = try? await gate.airport.userRecordID() {
            self.currentPassenger = try await gate.airport.userRecordID()
        }
        
        try await refresh()
    }

    func refresh() async throws {
        state = .loading
        do {
            let (p, s) = try await gate.getAllFlights(using: self)
            state = .loaded(privateFlights: p, sharedFlights: s)
        } catch {
            state = .error(error)
        }
    }
}
