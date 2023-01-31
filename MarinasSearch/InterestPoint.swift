//
//  InterestPoint.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 1/29/23.
//

import Foundation

public struct InterestPoint {
    var id: String

    var resource: InterestPointType

    var name: String

    var web_url: URL // todo: optional?

    var location: Location

    var rating: Int?

    var review_count: Int

    var images: ImageCollection
}

extension InterestPoint {
    struct Location {
        var lat: Float
        var lon: Float
        var what3words: String
    }

    struct ImageCollection {
        var data: [ImageData]
        var total_count: Int
    }

    struct ImageData {
        var thumbnail_url: URL?
        var small_url: URL?
        var medium_url: URL?
        var banner_url: URL?
        var full_url: URL?
    }
}

public enum InterestPointType: String, CaseIterable, Codable {
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
