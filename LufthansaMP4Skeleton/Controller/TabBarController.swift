//
//  ViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/2/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//


import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var flight : FlightClass!
    var airport : AirportClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        FavoritesData.favorites = []
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LufthansaAPIClient.getAuthToken {
            
            
            LufthansaAPIClient.getAirportDetails(code: "SFO", UIview: self, completion: ({ airport in
                self.airport = airport
            }))
        }
        
        let flightReqTab = FlightStatusViewController()
        let flightReqTabItem = UITabBarItem(title: "Flight", image: UIImage(named: "flight.png"), selectedImage: UIImage(named: "flight.png"))
        flightReqTab.tab = self
        flightReqTab.tabBarItem = flightReqTabItem
        
        let airportInfoTab = AirportsViewController()
        let airportInfoTabItem = UITabBarItem(title: "Airports", image: UIImage(named: "airport.png"), selectedImage: UIImage(named: "airport.png"))
        airportInfoTab.tabViewController = self
        airportInfoTab.tabBarItem = airportInfoTabItem
        
        let favoritesTab = FavoritesViewController()
        let favoritesTabItem = UITabBarItem(title: "Favorites", image: UIImage(named: "favorite.png"), selectedImage: UIImage(named: "favorite.png"))
        favoritesTab.tab = self
        favoritesTab.tabBarItem = favoritesTabItem
        
        
        
        self.viewControllers = [flightReqTab, airportInfoTab, favoritesTab]
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFlightInfo" {
            let destinationVC = segue.destination as! FlightInfoViewController
            destinationVC.flight = flight
        }
        
        if segue.identifier == "toAirportInfo" {
            
            let destinationVC = segue.destination as! AirportInfoViewController
            destinationVC.airport = airport
            
            
            
        }
    }
    
    
}

