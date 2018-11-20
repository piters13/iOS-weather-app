//
//  SearchCityViewController.swift
//  weather__pm
//
//  Created by Piotrek on 03/11/2018.
//  Copyright © 2018 Piotrek. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    var cities = [String : Int]()
    
    let locationManager = CLLocationManager()
    var locations: CLLocation?
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var searchByLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.findCity(searchBar.text!)
    }
    
    @IBAction func searchByLocationButtonPressed(_ sender: Any) {
        self.findNearestCities()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    private func findCity(_ searchedCity: String) {
        let url: URL? = URL(string: "https://www.metaweather.com/api/location/search/?query=\(searchedCity)")
        let defaultSession = URLSession(configuration: .default)
        var task: URLSessionDataTask?
        
        task = defaultSession.dataTask(with: url!) {data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    self.addFoundedCities(jsonObject as! [[String: AnyObject]])
                    self.tableView.reloadData()
                }
            }
        }
        
        task?.resume()
    }
    
    private func findNearestCities() {
        let url: URL? = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(locations!.coordinate.latitude),\(locations!.coordinate.longitude)")
        let defaultSession = URLSession(configuration: .default)
        var task: URLSessionDataTask?

        task = defaultSession.dataTask(with: url!) {data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {

                DispatchQueue.main.async {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])

                    self.addFoundedCities(jsonObject as! [[String: AnyObject]])
                    self.tableView.reloadData()
                }
            }
        }

        task?.resume()
    }
    
    private func addFoundedCities(_ response: [[String: AnyObject]]) {
        cities = [:]
        for city in response {
            cities[city["title"] as! String] = (city["woeid"] as! Int)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? TableViewController {
            if let cell = sender as? UITableViewCell {
                let alreadyAdded = viewController.cities.contains {city in
                    return city.name == cell.textLabel?.text
                }
                if !alreadyAdded {
                    viewController.cities.append(City(id: cities[(cell.textLabel?.text)!]!, name: (cell.textLabel?.text)!))
                    
                    viewController.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath)
        let city = Array(cities.keys)[indexPath.row]
        cell.textLabel?.text = city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "UnwindSegue", sender: cell)
        // _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //        if status == .authorizedWhenInUse {
        //            locationManager.requestLocation()
        //        }
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locations = locations.last!
        fetchCityAndCountry(from: manager.location!) { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.currentLocation.text = city + ", " + country
            //print(city + ", " + country)
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
}
