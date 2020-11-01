//
//  AddLocationViewController.swift
//  weatherApp
//
//  Created by Nikolay Kalchev on 31.10.20.
//  Copyright © 2020 Nikolay Kalchev. All rights reserved.
//

import UIKit

class AddLocationViewController : UIViewController {
    @IBOutlet weak var locationSearchField: UITextField!
    
    @IBOutlet weak var LocationTableView: UITableView!
    // MARK: - Properties
    var locationData = LocationData()
    var weatherManager = WeatherManager()
    override func viewDidLoad() {
    super.viewDidLoad()
        LocationTableView.dataSource = self
        LocationTableView.delegate = self
        locationSearchField.delegate = self
        
}
}
    
    //MARK: - UITableViewDataSource
extension AddLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData.location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = locationData.location[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension AddLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        locationData.location.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
}
// MARK: - UITextFieldDelegate

extension AddLocationViewController : UITextFieldDelegate {
    @IBAction func addPressed (_ sender: UIButton) {
        locationSearchField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationSearchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if locationSearchField.text != "" {
            return true
        } else {
            locationSearchField.placeholder = "Enter a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = locationSearchField.text {
            let newRowIndex = locationData.location.count
            locationData.location.append(text)
            let indexPath = IndexPath(row: newRowIndex, section: 0)
            let indexPaths = [indexPath]
            LocationTableView.insertRows(at: indexPaths, with: .automatic)
        }
        locationSearchField.text = ""
    
    }
}




