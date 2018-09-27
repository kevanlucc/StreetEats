//
//  ViewController.swift
//  newmultiMap
//
//  Created by Adriel Tolentino on 9/24/18.
//  Copyright © 2018 StreetEats. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        createAnnotation(locations: annoLocation)
        
        let urlString = "http://35.227.25.29/api/v1/states"
        guard let url = URL(string: urlString) else { return }
        
        print(urlString)
        
        struct Article: Codable {
            let __class__: String
            let created_at: String
            let id: String
            let name: String
            let updated_at: String
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("printing error")
            print(error as Any)
            //    print("Printing response")
            //     print(response as Any)
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            print(data as NSData)
            print(type(of: data))
            do {
                print("In json decoder")
                let articlesData = try JSONDecoder().decode([Article].self, from: data)
                for i in articlesData {
                    print(i.name)
                }
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
    }
    
    // Annotate Multiple Location
    let annoLocation = [
        ["title": "Sisig Cart", "latitude": 37.7880, "longitude": -122.4075, "Menu": "Filipino food"],
        ["title": "Sisig Cart", "latitude": 37.7910, "longitude": -122.4085, "Menu": "Filipino food"],
        ["title": "Elotes Cart", "latitude": 37.7912, "longitude": -122.4194, "Menu": "Corn food"],
        ]
    
    // Iterate through multiple location and mark points in the map
    func createAnnotation(locations: [[String: Any]]) {
        for location in locations {
            let locate = CLLocationCoordinate2DMake(
                location["latitude"] as! CLLocationDegrees,
                location["longitude"] as! CLLocationDegrees)
            
            let annotations = MKPointAnnotation()
            annotations.coordinate = locate
            annotations.title = location["title"] as? String
            annotations.subtitle = location["Menu"] as? String
            mapView.addAnnotation(annotations)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
