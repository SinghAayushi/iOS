//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Aayushi Singh on 06/03/21.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, CityChangeDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var WeatherValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    
    let locationManager = CLLocationManager()
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b82d6d10e5bbf96fef461b87f9374d24"
    let weatherDataModel = WheatherDataModel()
    var userDefaults = UserDefaults.standard
    var cityNameArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        fetchDataFromDefaultsAndUpdateList()
    }
    
    //MARK: - Networking
    /*
     func - getWheather()
     Weather API call maker
     */
    func getWheather(lon: String?, lat: String?, city: String?){
        var url = ""
        if let city = city{
            let urlToProcess = "\(WEATHER_URL)?q=\(city)&appid=\(APP_ID)"
            url = urlToProcess.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            //url = urlToProcess.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }else if let lat = lat, let lon = lon{
            url = "\(WEATHER_URL)?lat=\(lat)&lon=\(lon)&appid=\(APP_ID)"
        }

        //URL request for weather data fetch
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [weak self] in
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                _ = NSString(data: data!, encoding:
                       String.Encoding.ascii.rawValue)!
                if let data = data {
                    do {
                        let json = try JSON(data: data)
                        self!.updateWheatherData(json: json)
                    } catch {
                        print(error)
                    }
                }
               }
               else{
                //shows alert box if the searched city is not available in the list
                self!.showAlertView()
                print(error.debugDescription)
               }
           }
       }
        task.resume()
    }
    
    /*
     func - updateWheatherData()
     Updates the data in model after receiving from the API
     */
    func updateWheatherData(json : JSON){
        let wheatherDataTemp = json["main"]["temp"].double
        if let weatherData = wheatherDataTemp {
            //Temperature retrieval from API response
            weatherDataModel.temp = Int (weatherData - 273.5)
            
            //City name retrieval from API response
            let city = json["name"].stringValue
            weatherDataModel.city = city
            appendCity(city: city)
            
            //Condition retrieval from API response - decides the image to be displayed on the image view based on the
            // condition
            let condition = json["weather"][0]["id"].intValue
            weatherDataModel.condition =  condition
            let weatherIcon = weatherDataModel.updateWeatherIcon(condition: condition)
            weatherDataModel.weatherIcon = weatherIcon
            
            // date time and time zone retrieval from API response
            let dateTime = json["dt"].intValue
            let timeZone = json["timezone"].intValue
            
            //dateTimeFormater - function converts the time into the location based time zone
            let stringdt = dateTimeFormater(dateTime: dateTime, timeZone: timeZone)
            weatherDataModel.dateTime = stringdt

            //weather description (Cloudy, Rainy, Haze, etc.) retrieval from API response
            let weatherDescription = json["weather"][0]["description"].stringValue
            weatherDataModel.weatherString = weatherDescription
            
            //Updates the UI with fetched data
            updateUIWithWeatherData()
        }
    }
    /*
     appends the city name if it's not available in the list
     List maintains only 10 enties
     */
    func appendCity(city: String){
        if !self.cityNameArray.contains(city){
            if self.cityNameArray.count >= 10{
                //if cities count is 10 then ist entry is being removed
                self.cityNameArray.remove(at: 0)
            }
            
            self.cityNameArray.append(city)
            saveData()
        }
        
    }
    
    //MARK: - UI Action handler
    @IBAction func nextButton(_ sender: Any) {
        performSegue(withIdentifier: "toDetailView", sender: self)
    }
    
    override
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let destinationVC = segue.destination as! CitySearchViewController
            destinationVC.cityChangeDelegate = self
            destinationVC.cityList = self.cityNameArray
        }
    }
    
    //MARK: - Protocol method
    func cityChangefunction(cityName: String) {
        getWheather(lon: nil, lat: nil, city: cityName)
    }
    
    
    //MARK:- Update UI with data
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        tempValue.text = "\(weatherDataModel.temp) ℃"
        conditionImageView.image = UIImage (named: weatherDataModel.weatherIcon)
        dateValue.text = weatherDataModel.dateTime
        WeatherValue.text = weatherDataModel.weatherString.capitalized
    }
    
    func dateTimeFormater(dateTime: Int, timeZone: Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(dateTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
        dateFormatter.timeZone =  TimeZone(secondsFromGMT: timeZone)
        let localDate = dateFormatter.string(from: date)
        return localDate
    }

}

//MARK: - Location manager
extension ViewController{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print ("longitude : \(location.coordinate.longitude) latitude: \(location.coordinate.latitude)")
            
            let longitude =  location.coordinate.longitude
            let latitude = location.coordinate.latitude

            getWheather(lon: String (longitude), lat:  String (latitude), city: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)

        //the long and lat value is passed to the getWeather method  as default location
        self.getWheather(lon: "79.088860", lat: "21.146633", city: nil)
    }
}

//MARK: - Alert View
extension ViewController{
    func showAlertView(){
        let alert = UIAlertController(title: "Error", message: "City not found!!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "ok", comment: "Ok"), style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - User defaults operations
extension ViewController{
    //MARK: data saving methods
    func saveData(){
        if #available(iOS 12.0, *) {
          // use iOS 12-only feature
          do {
            let itemData: Data = try NSKeyedArchiver.archivedData(withRootObject: self.cityNameArray, requiringSecureCoding: false)
              self.userDefaults.set(itemData, forKey: "cityName")
                self.userDefaults.synchronize()
          } catch {
            fatalError("err")
          }
      } else {
          let itemData = NSKeyedArchiver.archivedData(withRootObject: self.cityNameArray)
          self.userDefaults.set(itemData, forKey: "cityName")
      }
                       
    }
    
    
    func fetchDataFromDefaultsAndUpdateList(){
        if let unarchivedObject = userDefaults.data(forKey: "cityName") {
           do {
                guard let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedObject) as? [String] else {
                        fatalError("loadWidgetDataArray - Can't get Array")
                    }
                self.cityNameArray = array

                } catch {
                    fatalError("loadWidgetDataArray - Can't encode data: \(error)")
                }
            }
    }
}



