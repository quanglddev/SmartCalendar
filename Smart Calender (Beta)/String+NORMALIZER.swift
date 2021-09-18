//
//  String+NORMALIZER.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/24/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

extension String {
    
    //Works with String+INDEX
    func convertTimeToMinuteTH(time: String) -> Int {
        let hour = time[0...1]
        let minute = time[3...4]
        let period = time[6...7]
        var result: Int = 0
        if period == "am" {
            result = (Int(hour)! * 60 / 5) + (Int(minute)! / 5)
        }
        else if period == "pm"{
            result = (Int(hour)! * 60 / 5) + (Int(minute)! / 5) + 12 * 60 / 5
        }
        return result
    }
    
    subscript(time: String) -> Int {
        let hour = time[0...1]
        let minute = time[3...4]
        let period = time[6...7]
        var result: Int = 0
        if period == "am" {
            result = (Int(hour)! * 60 / 5) + (Int(minute)! / 5)
        }
        else if period == "pm"{
            result = (Int(hour)! * 60 / 5) + (Int(minute)! / 5) + 12 * 60 / 5
        }
        return result
    }

}
