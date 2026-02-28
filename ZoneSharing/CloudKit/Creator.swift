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

@Observable @MainActor public class Creator {
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
