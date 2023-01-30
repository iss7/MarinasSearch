//
//  InterestPoint.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

public enum InterestPoint: String, CaseIterable, Codable {
    case anchorage
    case bridge
    case ferry
    case harbor
    case inlet
    case landmark
    case lighthouse
    case lock
    case marina
    case ramp

    var iconLocation: String {
        "\(rawValue)_icon"
    }
}
