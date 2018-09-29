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
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var ref: DatabaseReference!
    var refHandle: UInt!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.userTrackingMode = .follow
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        self.mapView.delegate = self
        //createAnnotation(locations: annoLocation)
        
        // grabbing data
        ref = Database.database().reference()
        // Grabs data from the database hierarchy as a snapshot
        refHandle = ref.observe(.value,
                                with: { (snapshot) in
                                    if snapshot.childrenCount == 0 {
                                        return
                                    }
    })
        // Referencing data inside the "Food" dictionary
        ref.child("Food").observe(.childAdded, with: { (snapshot) in
            print("printing snapshot.value")
            let latitude = (snapshot.value as AnyObject?)!["latitude"] as! String
            let longitude = (snapshot.value as AnyObject?)!["longitude"] as! String
            let cartName = (snapshot.value as AnyObject?)!["cartName"] as! String
            let typeFood = (snapshot.value as AnyObject?)!["typeFood"] as! String
            let hours = (snapshot.value as AnyObject?)!["hour"] as! Int
            let minutes = (snapshot.value as AnyObject?)!["minutes"] as! Int
            
            let locate = CLLocationCoordinate2DMake((Double(latitude)!), (Double(longitude)!))
            
            // Draw out marker on map 
            let annotations = MKPointAnnotation()
            annotations.coordinate = locate
            annotations.title = cartName
            print(hours)
            print(minutes)
            annotations.subtitle = "\(typeFood) \n\(hours) \(minutes)"
            self.mapView.addAnnotation(annotations)
        })
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomerAnnotation")
        annotationView.image = UIImage(named: "cart")
        annotationView.canShowCallout = true
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        annotationView.detailCalloutAccessoryView = subtitleView
        return annotationView
    }
    
    // function that zooms in to the user's location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
