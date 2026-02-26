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
@MainActor
public protocol Sociable: AnyObject, Observable {
    associatedtype Item: Socialite
   
    var state: SocialState<Item> { get set }
    var gate: CKGate { get set }
    var currentPassenger: CKPassenger? { get set }
   
    func startSocializing()
    func refresh() async throws
}

extension Sociable {
    func startSocializing() async throws {
        self.gate = CKGate.privateGate(containerIdentifier: Config.containerIdentifier)
       
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
