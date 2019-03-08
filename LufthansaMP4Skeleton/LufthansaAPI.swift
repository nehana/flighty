////
////  LufthansaAPI.swift
////  LufthansaMP4Skeleton
////
////  Created by Neha Nagabothu on 3/6/19.
////  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import SwiftyJSON
//
//
//class LufthansaAPIHelper {
//
//    //These are where we will store all of the authentication information. Get these from your account at developer.lufthansa.com.
//    static let clientSecret = "42wwjUxNgP"
//    static let clientID = "tgkr7dddgr6pbduefbkjy7re"
//
//    //This variable will store the session's auth token that we will get from getAuthToken()
//    static var authToken: String?
//
//    //This function will request an auth token from the lufthansa servers
//    static func getAuthToken(completion: @escaping () -> ()){
//
//        //This is the information that will be sent to the server to authenticate our device
//        let requestURL = "https://api.lufthansa.com/v1/oauth/token"
//        let parameters = ["client_id": "\(clientID)", "client_secret": "\(clientSecret)", "grant_type": "client_credentials"]
//
//        //This is the POST request made to the lufthansa servers to get the authToken for this session.
//        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: URLEncoding(), headers: ["Content-Type": "application/x-www-form-urlencoded"]).responseJSON { response in
//
//            //Converts response to JSON object and sets authToken variable to appropriate value
//            let json = JSON(response.result.value!)
//            self.authToken = json["access_token"].stringValue
//
//            print("Auth token: " + self.authToken!)
//            print("This key expires in " + json["expires_in"].stringValue + " seconds\n")
//
//            //Runs completion closure
//            completion()
//        }
//    }
//
//    //This function will get the status for a flight. FlightNum format "LHXXX" Date format "YYYY-MM-DD"
//    static func getFlightStatus(flightNum: String, date: String, UIview: UIViewController, completion: @escaping (FlightClass) -> ()){
//
//        //Request URL and authentication parameters
//        let requestURL = "https://api.lufthansa.com/v1/operations/flightstatus/\(flightNum)/\(date)"
//        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
//
//        print("PARAMETERS FOR REQUEST:")
//        print(parameters)
//        print("\n")
//
//        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
//            //Makes sure that response is valid
//            guard response.result.isSuccess else {
//                print(response.result.error.debugDescription)
//                return
//            }
//            //Creates JSON object
//            let json = JSON(response.result.value)
//            print(json)
//            //Create new flight model and populate data
//            let flight = FlightClass()
//            flight.flightNumber = flightNum
//            flight.timeStatus = json["FlightStatusResource"]["Flights"]["Flight"]["FlightStatus"]["Definition"].stringValue
//            flight.originAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["AirportCode"].stringValue
//            flight.destAirport = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["AirportCode"].stringValue
//            flight.arrTime = json["FlightStatusResource"]["Flights"]["Flight"]["Arrival"]["ScheduledTimeUTC"]["DateTime"].stringValue
//            flight.depTime = json["FlightStatusResource"]["Flights"]["Flight"]["Departure"]["ScheduledTimeUTC"]["DateTime"].stringValue
//
//
//            var timeStatus: String
//            var originAirport: String
//            var destAirport: String
//            var arrTime: String
//            var depTime: String
//            var aircraftType: String
//            //var aircraftImage: UIView
//            var depTerminal: String
//            var arrTerminal: String
//            var depGate: String
//            var arrGate: String
//
//
//            completion(flight)
//
//
//        }
//    }
//
//
//    //This function will get the status for a flight. FlightNum format "LHXXX" Date format "YYYY-MM-DD"
//    static func getAirportInfo(code: String, UIview : UIViewController, completion: @escaping (AirportClass) -> ()){
//        //Request URL and authentication parameters
//        let requestURL = "https://api.lufthansa.com/v1/references/airports/\(code)?limit=20&offset=0&LHoperated=0"
//        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
//
//
//        print("PARAMETERS FOR REQUEST:")
//        print(parameters)
//        print("\n")
//
//        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
//            //Makes sure thhat response is valid
//            guard response.result.isSuccess else {
//                print(response.result.error.debugDescription)
//                return
//            }
//            //Creates JSON object
//            let json = JSON(response.result.value)
//            print(json)
//            //Create new flight model and populate data
//            let airport = AirportClass()
//            airport.airportCode = code
//            airport.lat = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Latitude"].stringValue
//            airport.lon = json["AirportResource"]["Airports"]["Airport"]["Position"]["Coordinate"]["Longitude"].stringValue
//            completion(airport)
//        }
//    }
//
//    static func getAllAirports(UIview : UIViewController, completion: @escaping ([AirportClass]) -> ()){
//        //Request URL and authentication parameters
//        let requestURL = "https://api.lufthansa.com/v1/references/airports/?limit=20&offset=0&LHoperated=0"
//        let parameters: HTTPHeaders = ["Authorization": "Bearer \(authToken!)", "Accept": "application/json"]
//
//
//        print("PARAMETERS FOR REQUEST:")
//        print(parameters)
//        print("\n")
//
//        Alamofire.request(requestURL, headers: parameters).responseJSON { response in
//            //Makes sure thhat response is valid
//            guard response.result.isSuccess else {
//                print(response.result.error.debugDescription)
//                return
//            }
//            //Creates JSON object
//            let json = JSON(response.result.value)
//            print(json)
//            //Create new flight model and populate data
//            var airports : [AirportClass] = []
//            for i in 0...19 {
//                let airport = AirportClass()
//                let number = i
//                airport.airportCode = json["AirportResource"]["Airports"]["Airport"][number]["AirportCode"].stringValue
//                airport.airportName = json["AirportResource"]["Airports"]["Airport"][number]["Names"]["Name"][0]["$"].stringValue
//                airport.lat = json["AirportResource"]["Airports"]["Airport"][number]["Position"]["Coordinate"]["Latitude"].stringValue
//
//                airport.lon = json["AirportResource"]["Airports"]["Airport"][number]["Position"]["Coordinate"]["Longitude"].stringValue
//                airports.append(airport)
//            }
//            completion(airports)
//        }
//    }
//}
//
