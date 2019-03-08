//
//  AirportsViewController.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/3/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import MapKit
class AirportsViewController: UIViewController, MKMapViewDelegate{
    
    var tabViewController : TabViewController!
    var mapView : MKMapView!
    var selected : MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.1, green: 0.74, blue: 0.61, alpha: 1.0)
        self.title = "Find Airports"
        
        mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        
        var mapRegion : MKCoordinateRegion  = MKCoordinateRegion()
        var coordinate :  CLLocationCoordinate2D = CLLocationCoordinate2D()
        coordinate.latitude = 48.8566
        coordinate.longitude = 2.3522
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 40
        mapRegion.span.longitudeDelta = 50
        
        mapView.setRegion(mapRegion, animated: true)
        
        
        LufthansaAPIClient.getAirports(UIview: self, completion: ({airports in
            
            for airport in airports {
                let paris = MKPointAnnotation()
                paris.title = "\(airport.airportName), \(airport.airportCode!)"
                paris.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees((airport.lat! as NSString).integerValue), longitude: CLLocationDegrees((airport.lon! as NSString).integerValue))
                self.mapView.addAnnotation(paris)
            }
            self.view.addSubview(self.mapView)
        }))
        
        
    }
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
            tabViewController.performSegue(withIdentifier: "toAirportInfo", sender: tabViewController)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selected = view.annotation as? MKPointAnnotation
            tabViewController.performSegue(withIdentifier: "toAirportInfo", sender: tabViewController)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}

