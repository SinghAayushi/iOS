//
//  File.swift
//  Climate Change
//
//  Created by aayushisingh on 07/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit

protocol CityChangeDelegate {
    func cityChangefunction(cityName : String)
}

class WheatherScreen: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    var cityChangeDelegate : CityChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func backPress(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func testButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "cityWeatherToThirdScreen", sender: self)
    }
    
    @IBAction func getWeather(_ sender: UIButton) {
        let cityText = cityTextField.text!
        cityChangeDelegate?.cityChangefunction(cityName: cityText)
        self.dismiss(animated: true, completion: nil )
    }
}
