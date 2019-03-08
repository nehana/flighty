//
//  FlightStatusViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/2/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class FlightStatusViewController: UIViewController {
    
    var flightyLabel: UILabel!
    var userFlightNum: UITextField!
    var datePicker: UIDatePicker!
    var datePickerButton: UITextField!
    var findFlightButton: UIButton!
    var tab: TabViewController!
    var date: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.74, blue: 0.61, alpha: 1.0)
        self.title = "Track Flights"
        
        flightyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        flightyLabel.center = CGPoint(x: view.frame.width / 2, y:  200 )
        flightyLabel.text = "Flighty"
        flightyLabel.textColor = UIColor.white
        flightyLabel.font = UIFont(name: "HelveticaNeue-Light", size: 50)
        flightyLabel.textAlignment = .center
        view.addSubview(flightyLabel)
        
        findFlightButton = UIButton(frame: CGRect(x: 20, y: view.frame.height -     150, width: view.frame.width - 40, height: 60))
        findFlightButton.backgroundColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
        findFlightButton.setTitle("Find my flight!", for: UIControl.State())
        findFlightButton.setTitleColor(UIColor.white, for: UIControl.State())
        findFlightButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        findFlightButton.layer.cornerRadius = 5
        findFlightButton.layer.borderWidth = 1
        findFlightButton.layer.borderColor = UIColor.black.cgColor
        findFlightButton.addTarget(self, action: #selector(flightInfo), for: .touchUpInside)
        view.addSubview(findFlightButton)
        
        userFlightNum = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 40.00));
        userFlightNum.center = CGPoint(x: view.frame.width / 2, y:   view.frame.height / 2 - 40)
        userFlightNum.placeholder = "Your flight number"
        userFlightNum.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        userFlightNum.backgroundColor = UIColor.white
        view.addSubview(userFlightNum)
        
        datePicker = UIDatePicker()
        datePickerButton = UITextField(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.7, height: 40.00));
        datePickerButton.center = CGPoint(x: view.frame.width / 2, y:  view.frame.height / 2)
        datePickerButton.placeholder = "When's your flight?"
        datePickerButton.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        datePickerButton.backgroundColor = UIColor.white
        view.addSubview(datePickerButton)
        
        
        
        self.navigationController?.isNavigationBarHidden = true
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let finishButton = UIBarButtonItem(title: "Finish", style: .plain, target: self, action: #selector(finishDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let exitButton = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitDatePicker));
        
        toolbar.setItems([finishButton,spaceButton,exitButton], animated: false)
        
        datePickerButton.inputAccessoryView = toolbar
        datePickerButton.inputView = datePicker
        
    }
    
    
    @objc func finishDatePicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datePickerButton.text = formatter.string(from: datePicker.date)
        date = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func exitDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func flightInfo() {
        guard let _ = date, let _ = userFlightNum.text else {
            return
        }
        LufthansaAPIClient.getFlightStatus(flightNum: userFlightNum.text!, date: date, UIview: self, completion: ({flight in
            self.tab.flight = flight
            self.tab.performSegue(withIdentifier: "toFlightInfo", sender: self.tab)
        }))
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

