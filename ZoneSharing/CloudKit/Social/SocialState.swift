//
//  SocialState.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

public enum SocialState<T: Socialite> {
    case loading
    case loaded(privateFlights: [Passengers<T>], sharedFlights: [Passengers<T>])
    case error(Error)
}
