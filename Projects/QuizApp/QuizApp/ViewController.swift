//
//  ViewController.swift
//  QuizApp
//
//  Created by aayushisingh on 04/10/20.
//  Copyright © 2020 aayushisingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UITextField!
    @IBOutlet weak var scoreTextView: UITextField!
    @IBOutlet weak var ProgressBar: UIView!
    
    var score:Int = 0
    var currentInd:Int = 0
    var allQuestion = QuestionBank()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        questionLabel.text = allQuestion.list[0].quest
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
    
        if sender.tag == 1 {
            checkAnswer(ansVal: true)
        }else {
            checkAnswer(ansVal: false)
        }
        currentInd = currentInd + 1
        nextQuestion()
   
    }
    
    func nextQuestion(){
        if currentInd <= 7{
            questionLabel.text = allQuestion.list[currentInd].quest
        }else{
            
            // create the alert
            let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)

            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: {UIAlertAction in
                self.startOver()
                
                }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
        
//        ProgressBar.frame.size.width = ((view.frame.size.width)/13) * CGFloat(currentInd + 1)
    }
    
    func startOver(){
        currentInd = 0
        score = 0
        scoreTextView.text =  "\(score)/8"
        questionLabel.text = allQuestion.list[currentInd].quest
    }
    
    func checkAnswer(ansVal:Bool){
        if allQuestion.list[currentInd].ans == ansVal{
            score = score + 1
        }

        scoreTextView.text = " \(score)/8"
    }
}

