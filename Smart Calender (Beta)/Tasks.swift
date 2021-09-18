//
//  Tasks.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/20/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit
import os.log

class Tasks: NSObject, NSCoding {
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let length = "length"
        static let lengthDisplay = "lengthDisplay"
        static let importanceLevel = "importanceLevel"
        static let openFrom = "openFrom"
        static let endAt = "endAt"
        static let enabled = "enabled"
    }
    
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var length: Int
    var lengthDisplay: String
    var importanceLevel: Int
    var openFrom: Int //In minuteth
    var endAt: Int //In minuteth
    var enabled: Bool // yes is enabled, no is disable, by default all tasks are enabled
    
    //var startTime: Int
    //var endTime: Int
    
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    
    //MARK: Initialization

    init?(name: String, photo: UIImage?, length: Int, lengthDisplay: String, importanceLevel: Int, openFrom: Int, endAt: Int, enabled: Bool) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        guard !name.isEmpty else {
            return nil
        }
        
        guard !lengthDisplay.isEmpty else {
            return nil
        }
        
        // The length must be between 0 and 288 inclusively
        guard (length >= 0) && (length <= 288) else {
            return nil
        }
        
        // The importanceLevel must be between 0 and 2 inclusively
        guard (importanceLevel >= 0) && (importanceLevel <= 2) else {
            return nil
        }
        
        // The openFrom & endAt must be beween 0 and 288 inclusively
        guard (openFrom >= 0) && (openFrom <= 288) && (endAt >= 0) && (endAt <= 288) else {
            return nil
        }
        
        //// StartTime must be smaller then EndTime
        //guard endTime > startTime else {
        //    return nil
        //}
        
        self.name = name
        self.photo = photo
        self.length = length
        self.lengthDisplay = lengthDisplay
        self.importanceLevel = importanceLevel
        self.openFrom = openFrom
        self.endAt = endAt
        self.enabled = enabled
        //self.startTime = startTime
        //self.endTime = endTime
    }
    
    
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(length, forKey: PropertyKey.length)
        aCoder.encode(lengthDisplay, forKey: PropertyKey.lengthDisplay)
        aCoder.encode(importanceLevel, forKey: PropertyKey.importanceLevel)
        aCoder.encode(openFrom, forKey: PropertyKey.openFrom)
        aCoder.encode(endAt, forKey: PropertyKey.endAt)
        aCoder.encode(enabled, forKey: PropertyKey.enabled)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The lengthDisplay is required too. If we cannot decode a name lengthDisplay, the initializer should fail.
        guard let lengthDisplay = aDecoder.decodeObject(forKey: PropertyKey.lengthDisplay) as? String else {
            os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        
        // Because photo is an optional property of Task, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let length = aDecoder.decodeInteger(forKey: PropertyKey.length)
        
        let importanceLevel = aDecoder.decodeInteger(forKey: PropertyKey.importanceLevel)
        
        let openFrom = aDecoder.decodeInteger(forKey: PropertyKey.openFrom)
        
        let endAt = aDecoder.decodeInteger(forKey: PropertyKey.endAt)
        
        let enabled = aDecoder.decodeBool(forKey: PropertyKey.enabled)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, length: length, lengthDisplay: lengthDisplay, importanceLevel: importanceLevel, openFrom: openFrom, endAt: endAt, enabled: enabled)
    }
    
    
    
    
}
