//
//  WeatherData.swift
//  weatherApp
//
//  Created by Nikolay Kalchev on 29.10.20.
//  Copyright © 2020 Nikolay Kalchev. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable {
    let temp: Double
}

struct Weather : Codable {
    let description : String
    let id : Int
}

