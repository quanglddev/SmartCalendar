//
//  MondayTask.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/23/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import os.log

class ScheduledTasks: NSObject, NSCoding {
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let length = "length"
        static let lengthDisplay = "lengthDisplay"
        static let importanceLevel = "importanceLevel"
        static let startAt = "openFrom"
        static let endAt = "endAt"
        static let arranged = "arranged"
        static let isNow = "isNow"
    }
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var length: Int
    var lengthDisplay: String
    var importanceLevel: Int
    var startAt: Int //In minuteth
    var endAt: Int //In minuteth
    var arranged : Bool // True is yes, False is no
    var isNow: Bool // True is yes, False is no
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("mondayTasks")
    
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, length: Int, lengthDisplay: String, importanceLevel: Int, startAt: Int, endAt: Int, arranged: Bool, isNow: Bool) {
        
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
        guard (startAt >= 0) && (startAt <= 288) && (endAt >= 0) && (endAt <= 288) else {
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
        self.startAt = startAt
        self.endAt = endAt
        self.arranged = arranged
        self.isNow = isNow
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
        aCoder.encode(startAt, forKey: PropertyKey.startAt)
        aCoder.encode(endAt, forKey: PropertyKey.endAt)
        aCoder.encode(arranged, forKey: PropertyKey.arranged)
        aCoder.encode(isNow, forKey: PropertyKey.isNow)
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
        
        let startAt = aDecoder.decodeInteger(forKey: PropertyKey.startAt)
        
        let endAt = aDecoder.decodeInteger(forKey: PropertyKey.endAt)
        
        let arranged = aDecoder.decodeBool(forKey: PropertyKey.arranged)
        
        let isNow = aDecoder.decodeBool(forKey: PropertyKey.isNow)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, length: length, lengthDisplay: lengthDisplay, importanceLevel: importanceLevel, startAt: startAt, endAt: endAt, arranged: arranged, isNow: isNow)
    }
}
