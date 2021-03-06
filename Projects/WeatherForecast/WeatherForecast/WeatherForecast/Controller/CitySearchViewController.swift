//
//  CitySearchViewController.swift
//  WeatherForecast
//
//  Created by Aayushi Singh on 06/03/21.
//

import UIKit

protocol CityChangeDelegate {
    func cityChangefunction(cityName : String)
}

class CitySearchViewController: UITableViewController {

    @IBOutlet weak var serchBarCell: UISearchBar!
    @IBOutlet var searchBar: UITableView!
    var cityChangeDelegate : CityChangeDelegate?
    
    var cityList: [String] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        serchBarCell.delegate = self

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.cityList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = self.cityList[indexPath.row]
         
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityChangeDelegate?.cityChangefunction(cityName: cityList[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK:- Search bar delegate method
extension CitySearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print ("search clicked")
        guard !serchBarCell.text!.isEmpty else {
            self.showToast(message: "Enter a city name!", font: .systemFont(ofSize: 12.0))
            return
        }
        cityChangeDelegate?.cityChangefunction(cityName: serchBarCell.text!)
        self.navigationController?.popViewController(animated: true)
    }

}


//MARK:- Toast message
extension CitySearchViewController {
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
