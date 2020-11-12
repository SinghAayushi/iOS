//
//  NewsTableViewController.swift
//  news
//
//  Created by aayushisingh on 04/11/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    var data = [NewsDataModel]()
    var currIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 5
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.imageView?.frame = cell.frame.offsetBy(dx: 5, dy: 5);
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        
       
        cell.clipsToBounds = true
//        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = self.data[indexPath.row].title
        return cell
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return self.data.count
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
//        headerView.backgroundColor = UIColor.gray
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currIndex = indexPath.row
        performSegue(withIdentifier: "tableCellToDetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController{
            print ("title:::: \(data[currIndex].title)")
            destination.selectedItem = data[currIndex]
        }
    }
    
    //MARK: - API call
    func getData(){
        let request = NSMutableURLRequest(url: NSURL(string: "http://newsapi.org/v2/top-headlines?country=us&apiKey=81329206c9cf4a559a39d45d7e478010")! as URL,
                                                       cachePolicy: .useProtocolCachePolicy,
                                                   timeoutInterval: 10.0)
       request.httpMethod = "GET" 

       let session = URLSession.shared
       let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
           guard let data = data, error == nil else { return }

           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
               let articles = json?["articles"] as? [[String: Any]] ?? []
               let totalResults = json?["totalResults"] as? Int ?? 0
               print(totalResults)
               for item in articles{
                   let curItem = NewsDataModel()
                   let value = item["source"] as! [String:Any]
                   let name = value["name"]
                   curItem.sourceName = name as? String ?? ""
                   curItem.author = item["author"] as? String ?? ""
                   curItem.content = item["content"] as? String ?? ""
                   curItem.description = item["description"] as? String ?? ""
                   curItem.title =  item["title"] as? String ?? ""
                   curItem.url = item["url"] as? String ?? ""
                   curItem.imageToURL = item["urlToImage"] as? String ?? ""
                   self.data.append(curItem)
               }
           
                DispatchQueue.main.async {
                    self.tableView.reloadData()
               }
               //print(articles)
           } catch {
               print(error)
           }
        
       })

       dataTask.resume()
    }

}

extension UITableViewCell{
    func shadowAndBorderForCell(yourTableViewCell : UITableViewCell){
        // SHADOW AND BORDER FOR CELL
        //yourTableViewCell.contentView.layer.cornerRadius = 5
        yourTableViewCell.contentView.layer.borderWidth = 0.5
        yourTableViewCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        yourTableViewCell.contentView.layer.masksToBounds = true
        yourTableViewCell.layer.shadowColor = UIColor.gray.cgColor
        yourTableViewCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        yourTableViewCell.layer.shadowRadius = 2.0
        yourTableViewCell.layer.shadowOpacity = 1.0
        yourTableViewCell.layer.masksToBounds = false
        yourTableViewCell.layer.shadowPath = UIBezierPath(roundedRect:yourTableViewCell.bounds, cornerRadius:yourTableViewCell.contentView.layer.cornerRadius).cgPath
    }
}
