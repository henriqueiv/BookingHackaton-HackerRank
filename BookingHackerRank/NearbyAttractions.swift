//
//  NearbyAttractions.swift
//  BookingHackerRank
//
//  Created by Henrique Valcanaia on 9/8/15.
//  Copyright (c) 2015 DarkShine. All rights reserved.
//

import Foundation
import CoreLocation

extension String {
    func toDouble() -> Double? {
        if let numberFromString = NSNumberFormatter().numberFromString(self){
            let doubleValue = numberFromString.doubleValue
            return doubleValue
        }
        return 0.0
    }
}

class NearbyAttractions:NSObject{
    func degreeToRadians(value:Double) -> Double{
        return value * 3.14159265359 / 180.0
    }
    
    struct Point: Printable {
        var id:Int
        var latitude:Double
        var longitude:Double
        
        var description:String{
            return "Point(\(self.id), \(self.latitude), \(self.longitude))"
        }
    }
    
    struct Visit:Printable {
        var id:Int
        var distance:Double
        var description:String{
            //        return String(format: "%.2f", self.distance)
            return "\(self.id)"
        }
    }
    
    
    func roundToPlaces(value:Double, decimalPlaces:Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    func distance_between(point1:Point, point2:Point) -> Double{
        var EARTH_RADIUS = 6371;//in km
        var point1_lat_in_radians  = degreeToRadians( point1.latitude );
        var point2_lat_in_radians  = degreeToRadians( point2.latitude );
        var point1_long_in_radians  = degreeToRadians( point1.longitude );
        var point2_long_in_radians  = degreeToRadians( point2.longitude );
        
        let sins = sin( point1_lat_in_radians ) * sin( point2_lat_in_radians )
        let cosin = cos( point1_lat_in_radians ) * cos( point2_lat_in_radians ) * cos( point2_long_in_radians - point1_long_in_radians)
        
        var distance = acos( sins + cosin ) * Double(EARTH_RADIUS)
        distance = roundToPlaces(distance, decimalPlaces: 2)
        
        return distance
    }
    
    func sortByDistanceAndId(this:Visit, that:Visit) -> Bool{
        return (this.distance == that.distance) ? (this.id < that.id) : (this.distance < that.distance)
    }
    
    func kmhToMmin(speedKmh:Double) -> Double{
        return (speedKmh * 1000 / 60)
    }
    
    func main(){
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        let file = "test.txt"
        if let directories = dirs {
            let dir = directories[0]; //documents directory
            let path = dir.stringByAppendingPathComponent(file);
            
            if let content = String(contentsOfFile: path, usedEncoding: nil, error: nil){
                let lines: [String] = split(content) { $0 == "\n" }
                let transport:NSDictionary = ["metro": 20, "bike":15, "foot":5]
                if let numberAttractions = lines.first?.toInt()!{
                    let indexNumberTestCases = numberAttractions+1
                    let numberTestCases = lines[indexNumberTestCases].toInt()!
                    
                    for indexTestCase in indexNumberTestCases+1...indexNumberTestCases+numberTestCases{
                        // Visits for test x
                        var visits:[Visit] = [Visit]()
                        
                        
                        // Visit
                        let testStr:[String] = split(lines[indexTestCase]){ $0 == " "}
                        let hotel = Point(id: indexTestCase, latitude: testStr[0].toDouble()!, longitude: testStr[2].toDouble()!)
                        let transportType = testStr[2]
                        let minutes = testStr[3].toDouble()!
                        let speedMmin = kmhToMmin(transport.objectForKey(transportType) as! Double)
                        let possibleDistanceToTravel = speedMmin * minutes
                        
                        for indexAttraction in 1..<indexNumberTestCases{
                            // Attraction
                            let attractionsStr: [String] = split(lines[indexAttraction]) { $0 == " " }
                            let attraction = Point(id: attractionsStr[0].toInt()!, latitude: attractionsStr[1].toDouble()!, longitude: attractionsStr[2].toDouble()!)
                            
                            
                            //-------------------------------------
                            let a = CLLocation(latitude: attraction.latitude, longitude: attraction.longitude)
                            let b = CLLocation(latitude: hotel.latitude, longitude: hotel.longitude)
                            //-------------------------------------
                            //                    println("From \(hotel.id) to \(p.id) \(a.distanceFromLocation(b)/1000)")
                            //                    println("From \(hotel.id) to \(p.id) \(v.distance)")
                            
                            let v = Visit(id: attraction.id, distance: distance_between(hotel, point2: attraction))
                            if (v.distance <= possibleDistanceToTravel) {
                                visits += [v]
                            }else{
                                println("nao vou: \(v.distance)")
                            }
                        }
                        visits.sort(sortByDistanceAndId)
                        println(visits)
                    }
                }
            }
        }
    }
    
}