//
//  ObservableViewModel.swift
//  ZoneSharing
//
//  Created by Rod Tavangar on 2/24/26.
//

import OSLog
import Foundation
import Observation

@available(iOS 17.0, *)
@MainActor @Observable
final class ViewModel {

    // MARK: - State

    enum State {
        case loading
        case loaded(privateFlights: [FlightManifest], sharedFlights: [FlightManifest])
        case error(Error)
    }

    // MARK: - Properties

    /// State directly observable by our view.
    private(set) var state: State = .loading
    /// Gate for CloudKit operations on the private database.
    let gate: CKGate

    // MARK: - Init

    nonisolated init() {
        self.gate = CKGate.privateGate(containerIdentifier: Config.containerIdentifier)
        Task { try await refresh() }
    }

    /// Initializer to provide explicit state (e.g. for previews).
    convenience init(state: State) {
        self.init()
        self.state = state
    }

    // MARK: - API

    /// Fetches contacts from the remote databases and updates local state.
    func refresh() async throws {
        state = .loading
        do {
            let (p, s) = try await CKGate.fetchAllFlights(airport: gate.airport)
            state = .loaded(privateFlights: p, sharedFlights: s)
        } catch {
            state = .error(error)
        }
    }
}
