//
//  LocationManager.swift
//  BookClub
//
//  Created by Malik Falana on 2/21/24.
//

import Foundation
import SwiftyJSON
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion()
    var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    var locationManager: CLLocationManager?
    var isLocationAvailable: Bool = false
    var locationUpdateGroup = DispatchGroup()
    
    var homeRegion = CLLocationCoordinate2D(latitude: 39.883030, longitude: -86.224060)

    private override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationServicesEnabled()
    }

    func locationServicesEnabled() {
        guard let locationManager = locationManager else { return }

        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            print("Location services are disabled. Prompt the user to enable them.")
            // You can show an alert here, asking the user to enable location services
        }
    }

    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your Location is restricted") // use alert
        case .denied:
            print("You have denied this app location privileges. Go into settings to change it") // use alert
        case .authorizedAlways, .authorizedWhenInUse:
            if !isLocationAvailable {
                locationUpdateGroup.enter()  // Enter the dispatch group
                locationManager.startUpdatingLocation()
            }
        @unknown default:
            break
        }
    }

    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            currentRegion = MKCoordinateRegion(center: coordinate, span: span)
            isLocationAvailable = true
            locationUpdateGroup.leave()  // Leave the dispatch group when location is updated
        }
    }

    func findNearbyLocations() async -> [MKMapItem]? {
        guard !isLocationAvailable else {
            print("Location information is already available.")
            // If location information is not available, request authorization and start updating location
            locationUpdateGroup.enter()
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.startUpdatingLocation()
            return []
        }

        let searchRequest = MKLocalSearch.Request()
        var data: [MKMapItem] = []

        searchRequest.naturalLanguageQuery = "libraries"
        searchRequest.region = MKCoordinateRegion(center: homeRegion, span: span)

        do {
            let response = try await MKLocalSearch(request: searchRequest).start()
            data = response.mapItems
            //print(data)
            return data
        } catch {
            print("There was an issue searching: \(error.localizedDescription)")
            return nil
        }
    }

}



