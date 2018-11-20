//
//  MapViewController.swift
//  weather__pm
//
//  Created by Piotrek on 19/11/2018.
//  Copyright © 2018 Piotrek. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapViewContoller: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: Double = 52.2319237
    var longtitude: Double = 21.0067265
    var cityName = String()
    
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = cityName
        let initialLocation = CLLocation(latitude: latitude, longitude: longtitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        mapView.addAnnotation(annotation)
        centerMapOnLocation(location: initialLocation)
    }
    
    let regionRadius: CLLocationDistance = 50000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
