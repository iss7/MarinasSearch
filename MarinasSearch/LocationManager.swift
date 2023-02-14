//
//  LocationManager.swift
//  MarinasSearch
//
//  Created by Isabel Sharp on 2/13/23.
//

import Foundation
import CoreLocation

public final class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager

    override init() {
        // Create a CLLocationManager and assign a delegate
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            // Handle location update

            let locationObject = UserLocation(
                lat: Float(latitude),
                lon: Float(longitude)
            )
            if let encoded = try? JSONEncoder().encode(locationObject) {
                UserDefaults.standard.set(encoded, forKey: "location")
            }
        }
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
        print(error)
    }

    func requestLocation() {
        // Request a user’s location once
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
    }

}

public struct UserLocation: Codable {
    var lat: Float
    var lon: Float
}


