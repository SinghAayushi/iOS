//
//  ViewController.swift
//  news
//
//  Created by aayushisingh on 02/11/20.
//  Copyright © 2020 aayushi. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage


class ViewController: UIViewController {
   
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var selectedItem: NewsDataModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        downloadImage()
        adjustUITextViewHeight()
        addHyperLinkToTextView()
        // Do any additional setup after loading the view.
    }

    func adjustUITextViewHeight()
    {
       //alamofire image to url does caching too
        let downloadURL = NSURL(string: selectedItem!.imageToURL)!
        imageView.af_setImage(withURL: downloadURL as URL)
        
        titleTextView.text = selectedItem?.title
       
        titleTextView.translatesAutoresizingMaskIntoConstraints = true
        titleTextView.sizeToFit()
        titleTextView.isScrollEnabled = false
    }
    
    func downloadImage(){
        let url = URL(string: selectedItem!.imageToURL)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    
    func addHyperLinkToTextView(){
        let attributedString = NSMutableAttributedString(string: "\(self.selectedItem!.description) \n\n\(self.selectedItem!.url)")
        let url = URL(string: self.selectedItem!.url)!

        // Set the 'click here' substring to be the link
        attributedString.setAttributes([.link: url], range: NSMakeRange(self.selectedItem!.description.count+3, self.selectedItem!.url.count))

        self.descriptionTextView.attributedText = attributedString
        self.descriptionTextView.isUserInteractionEnabled = true
        self.descriptionTextView.isEditable = false

        // Set how links should appear: blue and underlined
        self.descriptionTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }
        
}



//@IBAction func getDataButtonPressed(_ sender: UIButton) {
//
//        let request = NSMutableURLRequest(url: NSURL(string: "http://newsapi.org/v2/top-headlines?country=in&apiKey=81329206c9cf4a559a39d45d7e478010")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            guard let data = data, error == nil else { return }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
//                let articles = json?["articles"] as? [[String: Any]] ?? []
//                let totalResults = json?["totalResults"] as? Int ?? 0
//                print(totalResults)
//                for item in articles{
//                    let curItem = NewsDataModel()
//                    let value = item["source"] as! [String:Any]
//                    let name = value["name"]
//                    curItem.sourceName = name as? String ?? ""
//                    curItem.author = item["author"] as? String ?? ""
//                    curItem.content = item["content"] as? String ?? ""
//                    curItem.description = item["description"] as? String ?? ""
//                    curItem.title =  item["title"] as? String ?? ""
//                    curItem.url = item["url"] as? String ?? ""
//                    curItem.imageToURL = item["urlToImage"] as? String ?? ""
//                    print("=============================")
//                    print(curItem.content)
//                }
//                //print(articles)
//            } catch {
//                print(error)
//            }
//        })
//
//        dataTask.resume()
//    }
//    func getDataFromEdge(){
//        let request = NSMutableURLRequest(url: NSURL(string: "http://192.168.43.195/notifier/usermanager/deviceregistration/register")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//        request.allHTTPHeaderFields = ["authToken" : "abcd"]
//        request.httpMethod = "POST"
//        let json: [String: Any] = ["device": "ABC",
//                                   "registrationToken": "jshdgjs"]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            guard let data = data, error == nil else {return}
//            do {
//                let resData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//            }catch{
//
//            }
//        }
//        dataTask.resume()
//    }
