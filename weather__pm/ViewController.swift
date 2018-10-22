//
//  ViewController.swift
//  weather__pm
//
//  Created by Student on 16.10.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let url = URL(string: "https://www.metaweather.com/api/location/44418")
    let session = URLSession(configuration: .default)
    var dataTask : URLSessionDataTask?
    var weatherObject: [[String : AnyObject]]?
    var day: Int = 0
    
    @IBOutlet weak var currentDate: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var weatherCondition: UITextField!
    @IBOutlet weak var minTemp: UITextField!
    @IBOutlet weak var maxTemp: UITextField!
    @IBOutlet weak var wind: UITextField!
    @IBOutlet weak var downfall: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getWeatherData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getWeatherData() {
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                print ("Error: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                DispatchQueue.main.async {
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                    
                    self.setWeatherData(weatherObject: jsonObject as! [String : AnyObject])
                }
            }
        }
        
        dataTask?.resume()
    }
    
    func setWeatherData(weatherObject: [String : AnyObject]) {
        self.weatherObject = weatherObject["consolidated_weather"] as? [[String : AnyObject]]
        updateView()
    }
    
    func convertDateFormatter() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    func updateView() {
        currentDate.text = convertDateFormatter()
        city.text = "London"
        date.text = weatherObject?[day]["applicable_date"] as? String
        weatherCondition.text = weatherObject?[day]["weather_state_name"] as? String
        maxTemp.text = String(round(weatherObject?[day]["max_temp"] as! Double)) + " °C"
        minTemp.text = String(round(weatherObject?[day]["min_temp"] as! Double)) + " °C"
        wind.text = String(round(weatherObject?[day]["wind_speed"] as! Double)) + " mph " + (weatherObject?[day]["wind_direction_compass"] as! String)
        pressure.text = String(round(weatherObject?[day]["air_pressure"] as! Double)) + " mbar"
        
        let fall = weatherObject?[day]["weather_state_name"] as? String
        
        downfall.text = checkForFall(fall)
        
        let weather_abbr = weatherObject?[day]["weather_state_abbr"] as! String
        
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather_abbr).png")
        let data = try? Data(contentsOf: url!)
        icon.image = UIImage(data: data!)
        
        print(weatherObject)
    }
    
    func checkForFall(_ fall: String?) -> String?{
        var possible_falls = ["Snow", "Sleet", "Hail", "Thunderstorm", "Heavy Rain", "Light Rain", "Showers"]
        if possible_falls.contains(fall!) {
            return fall;
        } else {
            return "no precipitation"
        }
    }
    
    
    @IBAction func prev(_ sender: UIButton) {
        day -= 1
        if day == 0 {
            prevButton.isEnabled = false
        }
        nextButton.isEnabled = true
        self.updateView()
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        day += 1
        if day == 4 {
            nextButton.isEnabled = false
        }
        prevButton.isEnabled = true
        self.updateView()
    }
    
}
