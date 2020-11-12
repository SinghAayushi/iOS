//
//  ViewController.swift
//  Climate Change
//
//  Created by aayushisingh on 07/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, CityChangeDelegate {
    
    

    //instances
    let locationManager = CLLocationManager()
    let wheatherDataModel = WheatherDataModel()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b82d6d10e5bbf96fef461b87f9374d24"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func nextScreenButtonPress(_ sender: UIButton) {
        
        performSegue(withIdentifier: "homeToWheather", sender: self)
        
    }
    
    //MARK: Networking
    func getWheather(url: String, parameter: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameter).responseJSON {
            response in
            if response.result.isSuccess {
                print("Wheather data success")
                let jsonData: JSON = JSON (response.result.value!)
                print(jsonData)
                
                self.updateWheatherData(json: jsonData)
            }else{
                //print(response.result.error)
                self.cityLabel.text = "Some error happened"
            }
        }
        
    }
    
    //MARK: UI update
    func updateUIWithWeatherData(){
        cityLabel.text = wheatherDataModel.city
        tempView.text = "\(wheatherDataModel.temp) ℃"
        imageView.image = UIImage (named: wheatherDataModel.weatherIcon)
        
    }
    
    //MARK: Json Parsing
    func updateWheatherData(json : JSON){
        let wheatherDataTemp = json["main"]["temp"].double
        if let weatherData = wheatherDataTemp {
            wheatherDataModel.temp = Int (weatherData - 273.5)
            let city = json["name"].stringValue
            wheatherDataModel.city = city
            let condition = json["weather"]["0"]["id"].intValue
            wheatherDataModel.condition =  condition
            let weatherIcon = wheatherDataModel.updateWeatherIcon(condition: condition)
            wheatherDataModel.weatherIcon = weatherIcon
            updateUIWithWeatherData()
        }
    }
    
    
    //MARK: Location response
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print ("longitude : \(location.coordinate.longitude) latitude: \(location.coordinate.latitude)")
            
            let longitude =  location.coordinate.longitude
            let latitude = location.coordinate.latitude
            
            let param : [String : String] = ["lat" : String (latitude), "lon" : String(longitude), "appid" : APP_ID]
            getWheather(url: WEATHER_URL, parameter: param)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: weather city change code
    func cityChangefunction(cityName: String) {
        print(cityName)
        let param : [String : String] = ["q" : cityName, "appid" : APP_ID]
        getWheather(url: WEATHER_URL, parameter: param )
    }
    
    override
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToWheather" {
            let destinationVC = segue.destination as! WheatherScreen
            destinationVC.cityChangeDelegate = self
        }
    }
    
}

