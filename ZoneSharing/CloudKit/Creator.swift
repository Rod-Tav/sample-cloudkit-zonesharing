//
//  Creator.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

struct CKWorld {
    
}

@Observable @MainActor public class Creator: Commendable {
    var passengers = [String: CKPassenger]()
    var socialite: String?
    var moment: String?
    
    var socialte: Socialite? {
        guard let moment else { return nil }
        
        return self.atMoment(moment)
    }
    
    func atMoment(_ moment: UUID) async throws -> UUID {
        return passengers[socialte]
    }
}

public protocol Commendable {
    var moment: UUID { get set }
    
    func bigBang() async throws
    func exist(at moment: String) async throws
}

extension Commendable {
    func bigBang() async throws {
        try exist(at: moment)
    }
    
    func exist(at moment: UUID) async throws {
        self.moment = moment
    }
}
