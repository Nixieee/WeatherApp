//
//  ViewController.swift
//  weatherApp
//
//  Created by Nikolay Kalchev on 29.10.20.
//  Copyright © 2020 Nikolay Kalchev. All rights reserved.
//

import UIKit
import CoreLocation
import Network
class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    func alert(){
    let alert = UIAlertController(title: "Mobile Data is Turned Off", message: "Turn on mobile data or use Wi-Fi to access data.", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) {
        [] _ in

        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(actionOK)
        monitor.pathUpdateHandler = { pathUpdateHandler in
                       if pathUpdateHandler.status == .satisfied {
                           print("Internet connection is on.")
                       } else {
                        DispatchQueue.main.async{
                        self.present(alert, animated: true)
                        }
                       }
                   }

                   monitor.start(queue: queue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchField.delegate = self
        alert()
        }
    }


// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = "Enter a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.weatherConditionImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.conditionLabel.text? = weather.description.capitalizedFirst()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationButtonPressed(_ sender:UIButton) {
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeatherGPS(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

// MARK: - First letter uppercased
extension String {
func capitalizedFirst() -> String {
    let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
    let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
    return first.uppercased() + rest.lowercased()
}
}
