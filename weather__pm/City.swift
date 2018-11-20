//
//  City.swift
//  weather__pm
//
//  Created by Piotrek on 13/11/2018.
//  Copyright © 2018 Piotrek. All rights reserved.
//

import Foundation
import UIKit

class City {
    let id: Int
    let name: String
    var weather: [[String: AnyObject]]?
    
    let session = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?

    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func getWeatherData() {
        let url = URL(string: "https://www.metaweather.com/api/location/\(self.id)")
        
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print ("Error: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    self.weather = ((jsonObject as! [String: AnyObject])["consolidated_weather"] as? [[String: AnyObject]])
                }
            }
        }
        
        dataTask?.resume()
    }
    
    func setWeather(_ cell: TableViewCityCell){
        let url = URL(string: "https://www.metaweather.com/api/location/\(self.id)/")
        
        dataTask = session.dataTask(with: url!) {data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    self.weather = ((jsonObject as! [String: AnyObject])["consolidated_weather"] as? [[String: AnyObject]])
                    
                    let abbr = self.weather?[0]["weather_state_abbr"] as! String
                    let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(abbr).png")
                    let data = try? Data(contentsOf: url!)
                    
                    cell.imageView?.image = UIImage(data: data!)
                    cell.textLabel?.text = self.name
                    cell.detailTextLabel?.text = "\(String(round((self.weather?[0]["max_temp"] as! Double)*10)/10)) °C"
                }
            }
        }
        
        dataTask?.resume()
        
    }
}
