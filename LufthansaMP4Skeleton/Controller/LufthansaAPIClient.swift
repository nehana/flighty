//
//  LufthansaAPIClient.swift
//  LufthansaMP4Skeleton
//
//  Created by Max Miranda on 3/2/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LufthansaAPIClient {
    
    static let clientSecret = "4b9gTbkBXT"
    static let clientID = "jmck6cqpqdvt2naqzxk3et84"
    
    
    static var authToken: String?
    
    
    static func getAuthToken(completion: @escaping () -> ()){
        
        let requestURL = "https://api.lufthansa.com/v1/oauth/token"
        let parameters = ["client_id": "\(clientID)", "client_secret": "\(clientSecret)", "grant_type": "client_credentials"]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding(), headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { response in
            
            let json = JSON(response.result.value!)
            self.authToken = json["access_token"].stringValue
            
            print("Auth token: " + self.authToken!)
            print("This key expires in " + json["expires_in"].stringValue + " seconds\n")
            
            completion()
        }
    }
    
    static func getFlightStatus(flightNum: String, date: String, UIview: UIViewController, completion: @escaping (FlightClass) -> ()){
        
        let requestURL = "https://api.lufthansa.com/v1/operations/flightstatus/\(flightNum)/\(date)"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            
            let json = JSON(response.result.value)
            
            let flight = FlightClass()
            flight.flightNumber = flightNum
            flight.timeStatus = json["FlightStatusResource"]["Flights"]["Flight"]["FlightStatus"]["Definition"].stringValue
            flight.destAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["AirportCode"].stringValue
            flight.originAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["AirportCode"].stringValue
            flight.arrTime = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["ScheduledTimeUTC"]["DateTime"].stringValue
            flight.depTime = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["ScheduledTimeUTC"]["DateTime"].stringValue
            
            completion(flight)
            
            
        }
    }
    
    
    static func getAirportDetails(code: String, UIview : UIViewController, completion: @escaping (AirportClass) -> ()){
        
        let requestURL = "https://api.lufthansa.com/v1/references/airports/\(code)?limit=20&offset=0&LHoperated=0"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            
            let json = JSON(response.result.value)
            print(json)
            
            let airport = AirportClass()
            airport.airportCode = code
            airport.lat = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Latitude"].stringValue
            airport.lon = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Longitude"].stringValue
            completion(airport)
        }
    }
    
    static func getAirports(UIview : UIViewController, completion: @escaping ([AirportClass]) -> ()){
        
        let requestURL = "https://api.lufthansa.com/v1/references/airports/?limit=20&offset=0&LHoperated=0"
        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
        
        
        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
            
            guard response.result.isSuccess else {
                print(response.result.error.debugDescription)
                return
            }
            
            let json = JSON(response.result.value)
            
            var airports : [AirportClass] = []
            for i in 0...19 {
                let airport = AirportClass()
                airport.airportCode = json["AirportResource"]["Airports"]["Airport"][i]["AirportCode"].stringValue
                airport.airportName = json["AirportResource"]["Airports"]["Airport"][i]["Names"]["Name"][0]["$"].stringValue
                airport.lat = json["AirportResource"]["Airports"]["Airport"][i]["Position"]["Coordinate"]["Latitude"].stringValue
                
                airport.lon = json["AirportResource"]["Airports"]["Airport"][i]["Position"]["Coordinate"]["Longitude"].stringValue
                airports.append(airport)
            }
            completion(airports)
        }
    }
    
}

