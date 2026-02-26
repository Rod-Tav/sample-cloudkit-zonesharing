//
//  ZoneSharingTests.swift
//  ZoneSharingTests
//

import XCTest
import CloudKit
@testable import ZoneSharing

class ZoneSharingTests: XCTestCase {

    let viewModel = ViewModel()
    var idsToDelete: [CKRecord.ID] = []
    var zoneIDsToDelete: [CKFlight.ID] = []

    // MARK: - Setup & Tear Down

    override func tearDownWithError() throws {
        guard !idsToDelete.isEmpty else {
            return
        }

        let container = CKContainer(identifier: Config.containerIdentifier)
        let database = container.privateCloudDatabase
        let deleteExpectation = expectation(description: "Expect CloudKit to delete testing records")

        Task {
            _ = try await database.modifyRecords(saving: [], deleting: idsToDelete)
            _ = try await database.modifyRecordZones(saving: [], deleting: zoneIDsToDelete)
            idsToDelete = []
            zoneIDsToDelete = []
            deleteExpectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - CloudKit Readiness

    func test_CloudKitReadiness() async throws {
        // Fetch zones from the Private Database of the CKContainer for the current user to test for valid/ready state
        let container = CKContainer(identifier: Config.containerIdentifier)
        let database = container.privateCloudDatabase

        do {
            _ = try await database.allRecordZones()
        } catch let error as CKError {
            switch error.code {
            case .badContainer, .badDatabase:
                XCTFail("Create or select a CloudKit container in this app target's Signing & Capabilities in Xcode")

            case .permissionFailure, .notAuthenticated:
                XCTFail("Simulator or device running this app needs a signed-in iCloud account")

            default:
                XCTFail("CKError: \(error)")
            }
        }
    }

    // MARK: - CKShare Creation

    func testCreatingShare() async throws {
        // Create a temporary contact to create the share on.
        try await createTestContact()
        // Fetch private contacts, which should now contain the temporary contact.
        let privateContacts = try await fetchPrivateContacts()

        // Find the manifest of our test Contact.
        guard let manifest = privateContacts.first(where: { $0.gate == testContactGroup }) else {
            XCTFail("No matching test Flight Manifest (zone) found after fetching private contacts")
            return
        }

        // Find the test Contact in the manifest.
        guard let testContact = manifest.passengers.first(where: { $0.name == testContactName }) else {
            XCTFail("No matching test Contact found after fetching private contacts")
            return
        }

        idsToDelete.append(testContact.record.recordID)
        let flightZoneID = await manifest.airplane.flight!.zoneID
        zoneIDsToDelete.append(flightZoneID)

        let (share, _) = try await viewModel.gate.fetchOrCreateShare(manifest: manifest)

        idsToDelete.append(share.recordID)
    }

    // MARK: - Helpers

    /// For testing creating a `CKShare`, we need to create a `Contact` with a name we can reference later.
    private lazy var testContactName: String = {
        "Test\(UUID().uuidString)"
    }()

    /// We also need a contact group name for our test contact.
    private lazy var testContactGroup: String = {
        "Group\(UUID().uuidString)"
    }()

    /// Simple function to create and save a new `Contact` to test with. Immediately fails on any error.
    private func createTestContact() async throws {
        let flight = CKFlight(zoneName: testContactGroup)
        let fields: [String: CKRecordValue] = [
            "name": testContactName as CKRecordValue,
            "phoneNumber": "555-123-4567" as CKRecordValue
        ]
        try await viewModel.gate.checkIn(fields, onto: flight)
    }

    /// Uses the gate to fetch private contacts. Immediately fails on any error.
    private func fetchPrivateContacts() async throws -> [FlightManifest] {
        try await viewModel.gate.fetchAllContacts()
    }
}
