//
//  FlightDetailViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/3/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//


import UIKit
import MapKit
class FlightInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate {
    var flight: FlightClass!
    var flightImg: UIImageView!
    var mapView: MKMapView!
    var tab: UIViewController!
    var destButton: UIButton!
    var originButton: UIButton!
    
    var flightNumLabel: UILabel!
    var airport: AirportClass!
    
    var flightsTableView: UITableView! = UITableView()
    var allItems: [String]!
    var total: Int!
    
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        numLabel(flight.flightNumber)
        flightsTableView.frame = CGRect(x: 0, y: view.frame.height - 290, width: view.frame.width, height: 290)
        flightsTableView.delegate = self
        flightsTableView.allowsSelection = false
        flightsTableView.backgroundColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
        allItems = ["Status: \(flight.timeStatus!)", "Arrival Time: \(flight.arrTime!)", "Departure Time: \(flight.depTime!)", "Destination Airport: \(flight.originAirport!)", "Origin Airport: \(flight.destAirport!)"]
        flightsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.flightsTableView)
        flightImg = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4))
        flightImg.center = CGPoint(x: view.frame.width / 2, y: 310)
        flightImg.image = UIImage(named: "plane.jpg")
        flightImg.contentMode = .scaleAspectFit
        view.addSubview(flightImg)
        flightsTableView.dataSource = self;
        flightsTableView.delegate = self;
        flightsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "favDisplay")
        self.navigationItem.title = flight.flightNumber;
        let favorite = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveFlight))
        self.navigationItem.rightBarButtonItem = favorite
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flightsTableView.reloadData()
        
        
        mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: view.frame.height / 3)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        LufthansaAPIClient.getAirportDetails(code: flight.destAirport!, UIview: self, completion: ({startairport in
            
            
            var start = CLLocationCoordinate2D(latitude: CLLocationDegrees((startairport.lat! as NSString).integerValue), longitude: CLLocationDegrees((startairport.lon! as NSString).integerValue))
            
            LufthansaAPIClient.getAirportDetails(code: self.flight.originAirport!, UIview: self, completion: ({endairport in
                
                print(endairport.lon!)
                
                var end = CLLocationCoordinate2D(latitude: CLLocationDegrees((endairport.lat as! NSString).integerValue), longitude:CLLocationDegrees((endairport.lon as! NSString).integerValue))
                
                let locations = [
                    start,
                    end
                ]
                let sourcePlacemark = MKPlacemark(coordinate: start, addressDictionary: nil)
                let destinationPlacemark = MKPlacemark(coordinate: end, addressDictionary: nil)
                
                let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
                let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                
                let sourceAnnotation = MKPointAnnotation()
                
                if let location = sourcePlacemark.location {
                    sourceAnnotation.coordinate = location.coordinate
                }
                
                let destinationAnnotation = MKPointAnnotation()
                
                if let location = destinationPlacemark.location {
                    destinationAnnotation.coordinate = location.coordinate
                }
                
                self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
                
                let aPolyline = MKPolyline(coordinates: locations, count: locations.count)
                self.view.addSubview(self.mapView)
                self.mapView.addOverlay(aPolyline)
                
                
            }))
            
        }))
        
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline) {
            let polylineRender = MKPolylineRenderer(overlay: overlay)
            polylineRender.strokeColor = UIColor.green.withAlphaComponent(0.5)
            polylineRender.lineWidth = 5
            return polylineRender
        }
        return MKOverlayRenderer()
    }
    
    
    
    @objc func saveFlight() {
        FavoritesData.favorites.append(flight)
        
    }
    
    
    
    
    func numLabel(_ number: String!){
        flightNumLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        flightNumLabel.adjustsFontSizeToFitWidth = true
        flightNumLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        flightNumLabel.textAlignment = .center
        flightNumLabel.text = "\(number!)"
        flightNumLabel.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        view.addSubview(flightNumLabel)
        
        
        destButton = UIButton(frame:CGRect(x: 0, y: 0, width: view.frame.width / 3 + 40, height: 40))
        destButton.center = CGPoint(x: view.frame.width / 4, y: view.frame.height / 2 + 100)
        destButton.backgroundColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
        destButton.setTitle("Destination Airport", for: UIControl.State())
        destButton.setTitleColor(UIColor.black, for: UIControl.State())
        destButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        destButton.backgroundColor = .clear
        destButton.layer.cornerRadius = 5
        destButton.layer.borderWidth = 1
        destButton.layer.borderColor = UIColor.black.cgColor
        destButton.addTarget(self, action: #selector(arrival), for: .touchUpInside)
        view.addSubview(destButton)
        
        
        originButton = UIButton(frame:CGRect(x: 0, y: 0, width: view.frame.width / 3 + 40, height: 40))
        originButton.center = CGPoint(x: 3 * view.frame.width / 4, y: view.frame.height / 2 + 100)
        originButton.backgroundColor = UIColor(red: 0.20, green: 0.29, blue: 0.37, alpha: 1.0)
        originButton.setTitle("Origin Airport", for: UIControl.State())
        originButton.setTitleColor(UIColor.black, for: UIControl.State())
        originButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
        originButton.backgroundColor = .clear
        originButton.layer.cornerRadius = 5
        originButton.layer.borderWidth = 1
        originButton.layer.borderColor = UIColor.black.cgColor
        originButton.addTarget(self, action: #selector(departure), for: .touchUpInside)
        view.addSubview(originButton)
    }
    
    
    @objc func arrival() {
        LufthansaAPIClient.getAirportDetails(code: flight.destAirport!, UIview: self,  completion: ({ (Airport) in
            self.airport = Airport
            self.performSegue(withIdentifier: "toAirportInfo", sender: self)
            
        }))
    }
    
    @objc func departure() {
        LufthansaAPIClient.getAirportDetails(code: flight.originAirport!, UIview: self,  completion: ({ (Airport) in
            self.airport = Airport
            self.performSegue(withIdentifier: "toAirportInfo", sender: self)
            
        }))
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = allItems [indexPath.row]
        cell.textLabel!.font = UIFont(name: "HelveticaNeue-Ultralight", size: 15)
        cell.textLabel?.textAlignment = .right
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            LufthansaAPIClient.getAirportDetails(code: flight.destAirport!, UIview: self,  completion: ({ (Airport) in
                self.airport = Airport
                self.performSegue(withIdentifier: "toAirportInfo", sender: self)
                
            }))
        } else if indexPath.row == 4 {
            LufthansaAPIClient.getAirportDetails(code: flight.originAirport!, UIview: self,  completion: ({ (Airport) in
                self.airport = Airport
                self.performSegue(withIdentifier: "toAirportInfo", sender: self)
                
            }))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAirportInfo" {
            let destinationVC = segue.destination as! AirportInfoViewController
            destinationVC.airport = airport
            
        }
    }
    
    
}

