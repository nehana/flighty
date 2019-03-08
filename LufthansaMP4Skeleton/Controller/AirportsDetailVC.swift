//
//  FlightDetailViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/4/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//


import UIKit
import MapKit
class AirportInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  MKMapViewDelegate {
    var airport: AirportClass!
    var flight: FlightClass!
    var flightImg: UIImageView!
    var mapView: MKMapView!
    
    
    var airportNumLabel: UILabel!
    
    var airportTableView: UITableView! = UITableView()
    var total: Int!
    
    
    
    
    @objc override func viewDidLoad() {
        super.viewDidLoad()
        
        airportTableView.frame = CGRect(x: 0, y: view.frame.height - 290, width: view.frame.width, height: 290)
        airportTableView.delegate = self
        airportTableView.allowsSelection = false
        
        airportTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.airportTableView)
        flightImg = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 4))
        flightImg.center = CGPoint(x: view.frame.width / 2, y: 310)
        flightImg.image = UIImage(named: "plane.jpg")
        flightImg.contentMode = .scaleAspectFit
        view.addSubview(flightImg)
        airportTableView.dataSource = self;
        airportTableView.delegate = self;
        self.navigationItem.title = airport.airportName;
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        airportTableView.reloadData()
        
        mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 110, width: view.frame.width, height: view.frame.height / 3)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        
        
        var start = CLLocationCoordinate2D(latitude: CLLocationDegrees((airport.lat! as NSString).integerValue), longitude: CLLocationDegrees((airport.lon! as NSString).integerValue))
        
        
        let locations = [start]
        let sourcePlacemark = MKPlacemark(coordinate: start, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        
        self.mapView.showAnnotations([sourceAnnotation], animated: true )
        
        self.view.addSubview(self.mapView)
        
        
    }
    
    func numLabel(_ number: String!){
        airportNumLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        airportNumLabel.adjustsFontSizeToFitWidth = true
        airportNumLabel.center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2 + 100)
        airportNumLabel.textAlignment = .center
        airportNumLabel.text = "\(number!)"
        airportNumLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        view.addSubview(airportNumLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        return cell;
    }
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
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
    
    
    
}

