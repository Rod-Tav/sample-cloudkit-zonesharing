//
//  Creator.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

@Observable public class Creator {
    var time = [UUID: Socialite]()
    var currentSocialiteID: UUID?
    
    var currentSocialite: Socialite? {
        guard let currentSocialiteID else { return nil }
        
        return time[currentSocialiteID]
    }
    
    func exist(at moment: UUID) async throws -> Socialite {
        if let socialite = self.time[moment] {
            return socialite
        } else {
            throw InvalidTime()
        }
    }
}

private struct InvalidTime: Error {
    var errorDescription: String? { "Invalid or missing CKShare" }
}

private actor Airplane {
    public let id = UUID()
    var flight: CKFlight?
    var passengers = Set<Socialite>()

    var gate: String? {
        flight.getGate(from airport: CKAirport)
    }

    init(flight: CKFlight? = nil) {
        self.id = flight?.flightID ?? UUID().uuidString
        self.flight = flight
    }

    func board(_ passenger: T) {
        passengers.insert(passenger)
    }

    func deplane(_ passenger: T) {
        passengers.remove(passenger)
    }
}

