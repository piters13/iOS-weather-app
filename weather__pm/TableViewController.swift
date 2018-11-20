//
//  TableController.swift
//  weather__pm
//
//  Created by Piotrek on 26/10/2018.
//  Copyright © 2018 Piotrek. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    var cities: [City] = [
        City(id: 725003, name: "Torino"),
        City(id: 44418, name: "London"),
        City(id: 523920, name: "Warsaw")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = cities[indexPath.row]
        
        (cell as! TableViewCityCell).setNewCity(city)
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "SegueIndentifier", sender: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueIndentifier" {
            if let viewController = segue.destination as? ViewController {
                if let cell = sender as? TableViewCityCell{
                    //print(cell.city?.weather)
                    viewController.setWeatherData(weatherObject: (cell.city?.weather)!, city: (cell.city?.name)!)
                    viewController.day = 0
                }
            }
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    @IBAction func addNewCity(_ sender: Any) {
    }
}
