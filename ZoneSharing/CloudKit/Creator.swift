//
//  Creator.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation
import CloudKit

@Observable @MainActor public class Creator<T: Socialite<String>> {
    var passengers = [String: CKPassenger]()
    var currentPassenger: String?
    var currentPassengerId: String?
    
    var currentPassenger: Socialite? {
        guard let currentPassengerId else { return nil }
        return passengers[currentPassengerId]
    }
}
