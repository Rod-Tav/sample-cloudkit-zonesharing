//
//  View-Extensions.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import SwiftUI

public extension View {
    /// Sets max height to infinity which has center alignment by default
    func maxHeight(spacer alignment: Alignment?) -> some View {
        self
            .frame(
                maxHeight: .infinity,
                alignment: alignment ?? .center
            )
    }
}
