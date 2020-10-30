//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Nikolay Kalchev on 29.10.20.
//  Copyright © 2020 Nikolay Kalchev. All rights reserved.
//

import Foundation

struct WeatherModel {
    let condtitionID: Int
    let cityName: String
    let temperature: Double
    let description: String
    
    var temperatureString : String {
        return String(format: "%.1f" , temperature)
    }
    
    var conditionName: String {
        switch condtitionID {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud.bolt"
        
        default:
            return "cloud"
        }
    }
}

