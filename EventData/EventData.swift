//
//  EventData.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 3/21/24.
//

import Foundation

// A list of all track and field events
enum EventData: String, CaseIterable, Hashable, Identifiable {
    // Running events
    case hundredMeters = "100 Meters"
    case twoHundredMeters = "200 Meters"
    case fourHundredMeters = "400 Meters"
    case eightHundredMeters = "800 Meters"
    case fifteenHundredMeters = "1500 Meters"
    case sixteenHundredMeters = "1600 Meters"
    case threeThousandMeters = "3000 Meters"
    case steeplechase = "3000 Meter Steeplechase"
    case fiveThousandMeters = "5000 Meters"
    case tenThousandMeters = "10,000 Meters"
    case hurdles110Meters = "110 Meter Hurdles"
    case hurdles400Meters = "400 Meter Hurdles"
    case fourByOneHundredRelay = "4x100 Meter Relay"
    case fourByTwoHundredRelay = "4x200 Meter Relay"
    case fourByFourHundredRelay = "4x400 Meter Relay"
    // Field events
    case highJump = "High Jump"
    case longJump = "Long Jump"
    case tripleJump = "Triple Jump"
    case poleVault = "Pole Vault"
    case shotPut = "Shot Put"
    case discusThrow = "Discus Throw"
    case weightThrow = "Weight Throw"
    case hammerThrow = "Hammer Throw"
    case javelinThrow = "Javelin Throw"

    var id: String { self.rawValue }
}
