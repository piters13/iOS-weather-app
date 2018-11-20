//
//  TableViewCityCell.swift
//  weather__pm
//
//  Created by Piotrek on 06/11/2018.
//  Copyright © 2018 Piotrek. All rights reserved.
//

import Foundation
import UIKit

class TableViewCityCell: UITableViewCell {
    
    var city: City?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCityCellData(_ city: City) {
        let abbr = city.weather?[0]["weather_state_abbr"] as! String
        let url = URL(string: "https://www.metaweather.com/static/img/weather/png/\(abbr).png")
        let data = try? Data(contentsOf: url!)
        
        self.imageView?.image = UIImage(data: data!)
        self.textLabel?.text = city.name
        self.detailTextLabel?.text = "\(String(round((city.weather?[0]["max_temp"] as! Double)*10)/10)) °C"
        
        self.city = city
    }
    
    func setNewCity(_ city: City)  {
        self.city = city
        self.city?.setWeather(self)
    }
}
