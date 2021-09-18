//
//  Int+NORMALIZER.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/24/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

extension Int {
    
    subscript(time: Int) -> String {
        var result: String = ""
        var hour: Int
        var minute: Int
        hour = time * 5 / 60
        minute = (time - hour * 60 / 5) * 5
        if hour == 0 {
            if minute != 0 && minute < 10{
                result = "00:0\(minute) am"
            }
            else if minute != 0 && minute >= 10 {
                result = "00:\(minute) am"
            }
            else if minute == 0 {
                result = "00:00 am"
            }
        }
        else if (hour < 10){
            if minute != 0 && minute < 10{
                result = "0\(hour):0\(minute) am"
            }
            else if minute != 0 && minute >= 10 {
                result = "0\(hour):\(minute) am"
            }
            else if minute == 0 {
                result = "0\(hour):00 am"
            }
        }
        else if (hour >= 10 && hour < 12) {
            if minute != 0 && minute < 10{
                result = "\(hour):0\(minute) am"
            }
            else if minute != 0 && minute >= 10 {
                result = "\(hour):\(minute) am"
            }
            else if minute == 0 {
                result = "\(hour):00 am"
            }
        }
        else if hour >= 12 {
            hour = hour - 12
            if hour == 0 {
                if minute != 0 && minute < 10{
                    result = "00:0\(minute) pm"
                }
                else if minute != 0 && minute >= 10 {
                    result = "00:\(minute) pm"
                }
                else if minute == 0 {
                    result = "00:00 pm"
                }
            }
            else if (hour < 10){
                if minute != 0 && minute < 10{
                    result = "0\(hour):0\(minute) pm"
                }
                else if minute != 0 && minute >= 10 {
                    result = "0\(hour):\(minute) pm"
                }
                else if minute == 0 {
                    result = "0\(hour):00 pm"
                }
            }
            else if (hour >= 10 && hour < 12) {
                if minute != 0 && minute < 10{
                    result = "\(hour):0\(minute) pm"
                }
                else if minute != 0 && minute >= 10 {
                    result = "\(hour):\(minute) pm"
                }
                else if minute == 0 {
                    result = "\(hour):00 pm"
                }
            }
        }
        return result
    }

}
