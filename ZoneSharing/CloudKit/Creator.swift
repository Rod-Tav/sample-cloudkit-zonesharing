//
//  Creator.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

@Observable @MainActor public class Creator {
    var passengers = [String: CKPassenger]()
    var currentPassenger: String? // uid
    var currentPassengerId: String? // uuid
    
    var currentPassenger: Socialite? {
        guard let currentPassengerId else { return nil }
        return passengers[currentPassengerId]
    }
}
