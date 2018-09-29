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
import FirebaseDatabase
import Firebase
import GoogleSignIn

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, GIDSignInUIDelegate {
    
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var refHandle: UInt!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleButton()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        //createAnnotation(locations: annoLocation)
        
        // grabbing data
        ref = Database.database().reference()
        refHandle = ref.observe(.value,
                                with: { (snapshot) in
                                    let dataDict = snapshot.value as! [String: AnyObject]
    })
        ref.child("Food").observe(.childAdded, with: { (snapshot) in
            print("printing snapshot.value")
            let latitude = (snapshot.value as AnyObject!)!["latitude"] as! String
            let longitude = (snapshot.value as AnyObject!)!["longitude"] as! String
            let cartName = (snapshot.value as AnyObject!)!["cartName"] as! String!
            let typeFood = (snapshot.value as AnyObject!)!["typeFood"] as! String!
            
            let locate = CLLocationCoordinate2DMake((Double(latitude)!), (Double(longitude)!))
            
            let annotations = MKPointAnnotation()
            annotations.coordinate = locate
            annotations.title = cartName
            annotations.subtitle = typeFood
            self.mapView.addAnnotation(annotations)
        })
    }
    
    fileprivate func setupGoogleButton() {
        // Add google signin
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self as! GIDSignInUIDelegate
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        self.mapView.setRegion(region, animated: true)
    }
    
   /* // Annotate Multiple Location
    let annoLocation = [
        ["title": "Sisig Cart", "latitude": 37.7880, "longitude": -122.4075, "Menu": "Filipino food"],
        ["title": "Sisig Cart", "latitude": 37.7910, "longitude": -122.4085, "Menu": "Filipino food"],
        ["title": "Elotes Cart", "latitude": 37.7912, "longitude": -122.4194, "Menu": "Corn food"],
        ]*/
    
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
