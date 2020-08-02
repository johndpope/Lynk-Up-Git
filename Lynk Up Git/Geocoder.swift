//
//  Geocode.swift
//  Meep
//
//  Created by Katia K Brinsmade on 4/23/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI
import CoreLocation
import Mapbox
import MapboxGeocoder

class ViewModel: ObservableObject {
    
    @ObservedObject var locationManager = LocationManager()
    @Published var lat: Double?
    @Published var lon: Double?
    @Published var location: CLLocationCoordinate2D?
    @Published var name: CLPlacemark?
    @Published var searchResults: [GeocodedPlacemark] = []
    
    
//    init() {
//        lat = locationManager.lastLocation!.coordinate.latitude
//        lon = locationManager.lastLocation!.coordinate.longitude
//    }
    
    var userLatitude: CLLocationDegrees {
        return (locationManager.lastLocation?.latitude ?? 0)
    }

    var userLongitude: CLLocationDegrees {
       return (locationManager.lastLocation?.longitude ?? 0)
    }

    
    
    
    
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        //let geocoder = CLGeocoder()
        let geocoder = Geocoder(accessToken: "pk.eyJ1Ijoibmlja2JyaW5zbWFkZSIsImEiOiJjazh4Y2dzcW4wbnJyM2ZtY2V1d20yOW4wIn0.LY1H3cf7Uz4BhAUz6JmMww")
        let foptions = ForwardGeocodeOptions(query: address)
        print("hit this point")
        foptions.focalLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        geocoder.geocode(foptions) { (placemarks, attribution ,error) in
            guard let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate
                else {
                    completion(nil)
                    return
            }
            completion(location)
        }
    }
    
    
    
    
    func fetchCoords(address: String, completion: @escaping (Double, Double) -> Void){
        self.getLocation(from: address) { coordinates in
            print(coordinates ?? 0) // Print here
          self.location = coordinates // Assign to a local variable for further processing
            if let lat = coordinates?.latitude, let lon = coordinates?.longitude {
                completion(lat, lon)
            }
        }
    }

    
    
    
    
    
    func findResults(address: String) {
        let geocoder = Geocoder(accessToken: "pk.eyJ1Ijoibmlja2JyaW5zbWFkZSIsImEiOiJjazh4Y2dzcW4wbnJyM2ZtY2V1d20yOW4wIn0.LY1H3cf7Uz4BhAUz6JmMww")
        let foptions = ForwardGeocodeOptions(query: address)
        foptions.focalLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)
        foptions.maximumResultCount = 10
        geocoder.geocode(foptions) { (placemarks, attribution ,error) in
            guard let placemarks = placemarks else {
                return
            }
            self.searchResults = []
            for placemark in placemarks {
                self.searchResults.append(placemark)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getPOIName(from coordinateSet: CLLocation, completionHandler: @escaping (_ name: CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(coordinateSet, completionHandler: { (placemarks, error) in
            if error == nil {
                let topHit = placemarks?[0]
                completionHandler(topHit)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    
    func fetchPOIName(coordinateSet: CLLocation) {
        print("IS THIS WORKING")
        self.getPOIName(from: coordinateSet) { names in
            print(names ?? "No name found")
            self.name = names
            print("we hit this point in the code")
            //print("The point of interest here is \(self.name)" )
        }
    }
}

