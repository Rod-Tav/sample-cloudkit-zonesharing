//
//  Passengers.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

public struct Passengers<T: Socialite>: Sociable {
    public let id: String
    let gate: String
    let passengers: Set<T>
    let airplane: Airplane<T>
}
