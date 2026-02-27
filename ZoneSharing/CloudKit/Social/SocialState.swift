//
//  Moment.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/26/26.
//

import Foundation

public enum Moment<T: Socialite> {
    case deparated
    case arrived(privateFlights: Set<Passengers<T>>, sharedFlights: Set<Passengers<T>>)
    case delayed(error: Error)
}
