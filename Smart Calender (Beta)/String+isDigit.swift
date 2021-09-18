//
//  String+isDigit.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/25/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit

extension String {
    
    func isDigit(str: String) -> Bool {
        for key in str.unicodeScalars {
            if NSCharacterSet.decimalDigits.contains(key) {
                
            }
        }
    }
    
}
