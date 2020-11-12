//
//  ViewController.swift
//  Bitcoin Tracker
//
//  Created by aayushisingh on 14/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
//    let ROOT_API = "https://api.coindesk.com/v1/bpi/currentprice/"
    let ROOT_API = "https://api.coindesk.com/v1/bpi/currentprice/"
    
    let param: [String : String] = ["USD" : "INR"]
    
    let pickerViewData = ["USD", "INR", "AUD", "BRL","CAD" ,"CHF" ,
    "CLP" ,
    "CNY" ,
    "DKK" ,
    "EUR" ,
    "GBP" ,
    "HKD" ,
    "ISK" ,
    "JPY" ,
    "KRW" ,
    "NZD" ,
    "PLN" ,
    "RUB" ,
    "SEK" ,
    "SGD" ,
    "THB" ,
    "TRY" ,
    "TWD" ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        requestBitCoinPrice(url: "\(ROOT_API)\(pickerViewData[0]).json", selectedCurrency: pickerViewData[0])
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        print("Row :: \(pickerViewData[row])")
//        print(component)
        return pickerViewData[row]
   }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
         // use the row to get the selected row from the picker view
         // using the row extract the value from your datasource (array[row])
        
        let selectedCurrency = pickerViewData[row]
        let url = "\(ROOT_API)\(selectedCurrency).json"
        requestBitCoinPrice(url: url, selectedCurrency: selectedCurrency)
        print(url)
     }
    
    //MARK: networking
    func requestBitCoinPrice(url: String, selectedCurrency: String){
        
        AF.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    let jsonData: JSON = JSON (value)
                    self.updateUI(json: jsonData, cur: selectedCurrency)
                case .failure(let error):
                
                    print("Error:: \(String(describing: error.errorDescription))")
                }
        }
    
    }
    
    func updateUI(json: JSON, cur: String){
        let val =  json["bpi"]["\(cur)"]["rate"]
        priceLabel.text = val.stringValue
        
    }
}

