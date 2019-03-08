//
//  FavoritesViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/3/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var favorites : [FlightClass?] = []
    var tab : TabViewController! = nil
    var favoritesTableView: UITableView! = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = FavoritesData.favorites.sorted(by: {
            guard let first: String = ($0 as! FlightClass).depTime else { return false }
            guard let second: String = ($1 as! FlightClass).depTime else { return true }
            return first < second
        })
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let frame = UIScreen.main.bounds
        
        favoritesTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth,height: displayHeight - barHeight))
        favoritesTableView.register(TableViewCell.self, forCellReuseIdentifier: "favDisplay")
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.rowHeight = 120
        view.addSubview(favoritesTableView)
        
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flight = favorites[indexPath.row]
        LufthansaAPIClient.getFlightStatus(flightNum: (flight?.flightNumber)!, date: "2019-03-01", UIview: self, completion: ({flight in
            self.tab.flight = flight
            self.tab.performSegue(withIdentifier: "toFlightInfo", sender: self.tab)
        }))
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favDisplay", for: indexPath as IndexPath) as! TableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let flight = favorites[indexPath.row]
        cell.textLabel!.text = "Your Flight: \(flight?.flightNumber! ?? "")"
        cell.textLabel!.textAlignment = .center
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Ultralight" , size: 15)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.tablePlaneImg.image = UIImage(named: "plane.jpg")
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

