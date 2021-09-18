//
//  SmartSchedule.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/27/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

class SmartSchedule {
    
    //Mark: Properties
    var tasks = [Tasks]()
    var scheduledTasks = [ScheduledTasks]()
    var cantArrangeTask = [ScheduledTasks]()
    
    //MARK: private methods
    
    private func loadTasks() -> [Tasks]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Tasks.ArchiveURL.path) as? [Tasks]
    }
    
    private func loadSavedTasks(){
        if let savedTasks = loadTasks() {
            tasks += savedTasks
            //print(tasks.count)
        }
        else {
            print("Can't load")
        }
    }
    
    func sortTaskByImportance() -> [Tasks] {
        var sortedTasks = [Tasks]()
        var importantTasks = [Tasks]()
        var compulsoryTasks = [Tasks]()
        var optionalTasks = [Tasks]()
        
        for index in 0..<tasks.count{
            if tasks[index].importanceLevel == 0 {importantTasks.append(tasks[index]) }
            else if tasks[index].importanceLevel == 1 {compulsoryTasks.append(tasks[index])}
            else if tasks[index].importanceLevel == 2 {optionalTasks.append(tasks[index])}
            else {print("Error on ScheduledTableViewController line 108")}
        }
        
        sortedTasks = importantTasks + compulsoryTasks + optionalTasks
        
        return sortedTasks
    }
    
    func numSmallerClosest(ofArray: [Int], number: Int) -> Int {   // find a number in array that is smaller than 'number' the smallest
        if (ofArray.count > 1){
            let indexStart = ofArray.count - 1
            var resultIndex: Int = 0
            for index in stride(from: indexStart, to: 0, by: -1) {
                if ofArray[index] < number{
                    resultIndex = index
                    break
                }
            }
            return ofArray[resultIndex]
        }
        else{
            return 0
        }
    }
    
    func numLargerClosest(ofArray: [Int], number: Int) -> Int { // find a number in array that is bigger than 'number' the smallest
        if (ofArray.count > 1){
            var resultIndex: Int = 0
            for index in 0..<ofArray.count {
                if ofArray[index] > number {
                    resultIndex = index
                    break
                }
            }
            return ofArray[resultIndex]
        }
        else{
            return 0
        }
    }
    
    func sortTaskByTime() {
        var result = [ScheduledTasks]()
        var allStart: [Int] = []
        for index in 0..<scheduledTasks.count {
            allStart.append(scheduledTasks[index].startAt)
        }
        allStart.sort()
        for index in 0..<allStart.count {
            for i in 0..<scheduledTasks.count {
                if allStart[index] == scheduledTasks[i].startAt {
                    result.append(scheduledTasks[i])
                    break
                }
            }
        }
        scheduledTasks = result
    }
    
    func sortTaskByAlphabet() {
        var result = [ScheduledTasks]()
        var alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        for index in  0..<alphabet.count {
            for i in 0..<scheduledTasks.count {
                if scheduledTasks[i].name[0].lowercased() == alphabet[index] {
                    result.append(scheduledTasks[i])
                }
            }
        }
    }
    
    func sortTaskByArranged() {
        var result = [ScheduledTasks]()
        for index in 0..<scheduledTasks.count {
            result.append(scheduledTasks[index])
        }
        for index in 0..<cantArrangeTask.count {
            result.append(cantArrangeTask[index])
        }
        scheduledTasks = result
    }
    
    
    func getIndexOfCurrentTask() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hours = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let currentSecond = hours * 3600 + minutes * 60 + seconds
        
        
        for index in 0..<scheduledTasks.count {
            if ((scheduledTasks[index].startAt * 5 * 60) <= currentSecond) && ((scheduledTasks[index].endAt * 5 * 60) >= currentSecond) {
                scheduledTasks[index].isNow = true
                break
            }
        }
    }
    
    
    func scheduleTask() {
        var usedMinuteth: [Int] = []
        var indexScheduled = -1 //Index for ScheduledTasks
        
        
        //print(tasks.count)
        for index in 0..<tasks.count {
            if tasks[index].enabled == true {
                //print("All Tasks: \(tasks.count)")
                
                //Re-order usedMinuteth from small to large (Done)
                usedMinuteth.sort()
                
                //Creat a func reoder tasks by importanceLevel (Done)
                tasks = sortTaskByImportance()
                //print(tasks)
                
                let task = tasks[index]
                
                let minStart = task.openFrom
                let maxStart = task.endAt - task.length
                
                let smallerNum = numSmallerClosest(ofArray: usedMinuteth, number: maxStart)
                let largerNum = numLargerClosest(ofArray: usedMinuteth, number: minStart)
                
                if(!usedMinuteth.isEmpty){
                    if usedMinuteth.contains(minStart) && usedMinuteth.contains(maxStart){
                        if(usedMinuteth.contains(maxStart + task.length)){
                            if(task.length == usedMinuteth[usedMinuteth.index(of: maxStart)! + 1]){
                                scheduledTasks.append(ScheduledTasks(
                                    name: task.name,
                                    photo: task.photo,
                                    length: task.length,
                                    lengthDisplay: task.lengthDisplay,
                                    importanceLevel: task.importanceLevel,
                                    startAt: maxStart,
                                    endAt: maxStart + task.length,
                                    arranged: true,
                                    isNow: false)!)
                            }
                        }
                        else if (!usedMinuteth.contains(maxStart + task.length)) {
                            scheduledTasks.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: maxStart,
                                endAt: maxStart + task.length,
                                arranged: true,
                                isNow: false)!)
                        }
                        else {
                            //The task is not added due to overload time of day
                            print("usedMinuteth: \(usedMinuteth)")
                            print("openFrom: \(task.openFrom), endAt: \(task.endAt)")
                            print("minStart: \(minStart), maxStart: \(maxStart)")
                            print("Task \(task.name) can't be added due to overload time of day")
                            cantArrangeTask.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: maxStart,
                                endAt: maxStart + task.length,
                                arranged: false,
                                isNow: false)!)
                            continue
                        }
                        
                    }
                    else if usedMinuteth.contains(minStart) && !usedMinuteth.contains(maxStart) {
                        if (maxStart) >= smallerNum {
                            scheduledTasks.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: smallerNum, // + 1 for 5 minute break
                                endAt: smallerNum + task.length,
                                arranged: true,
                                isNow: false)!) // + 1 for 5 minute break
                            print("Task \(task.name) is added 1")
                            indexScheduled += 1
                        }
                        else {
                            print("usedMinuteth: \(usedMinuteth)")
                            print("openFrom: \(task.openFrom), endAt: \(task.endAt)")
                            print("maxStart: \(maxStart), taskLength: \(task.length), smallerNum: \(smallerNum)")
                            print("Task \(task.name) can't be added due to overload time of day 1")
                            cantArrangeTask.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: smallerNum, // + 1 for 5 minute break
                                endAt: smallerNum + task.length,
                                arranged: false,
                                isNow: false)!) // + 1 for 5 minute break
                            continue
                        }
                    }
                    else if !usedMinuteth.contains(minStart) && usedMinuteth.contains(maxStart) {
                        if (minStart + task.length) <= largerNum {
                            scheduledTasks.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: minStart, // - 1 for 5 minute break
                                endAt: minStart + task.length,
                                arranged: true,
                                isNow: false)!) // - 1 for 5 minute break
                            print("Task \(task.name) is added 2")
                            indexScheduled += 1
                        }
                        else {
                            print("usedMinuteth: \(usedMinuteth)")
                            print("openFrom: \(task.openFrom), endAt: \(task.endAt)")
                            print("minStart: \(minStart), taskLength: \(task.length), largerNum: \(largerNum)")
                            print("Task \(task.name) can't be added due to overload time of day 2")
                            cantArrangeTask.append(ScheduledTasks(
                                name: task.name,
                                photo: task.photo,
                                length: task.length,
                                lengthDisplay: task.lengthDisplay,
                                importanceLevel: task.importanceLevel,
                                startAt: minStart, // - 1 for 5 minute break
                                endAt: minStart + task.length,
                                arranged: false,
                                isNow: false)!) // - 1 for 5 minute break
                            continue
                        }
                    }
                    else if !usedMinuteth.contains(minStart) && !usedMinuteth.contains(maxStart) {
                        scheduledTasks.append(ScheduledTasks(
                            name: task.name,
                            photo: task.photo,
                            length: task.length,
                            lengthDisplay: task.lengthDisplay,
                            importanceLevel: task.importanceLevel,
                            startAt: minStart,
                            endAt: minStart + task.length,
                            arranged: true,
                            isNow: false)!)
                        print("Task \(task.name) is added 3")
                        indexScheduled += 1
                    }
                    else {
                        print("Unexpected result at line 92 ScheduledTableViewController")
                    }
                }
                else {
                    scheduledTasks.append(ScheduledTasks(
                        name: task.name,
                        photo: task.photo,
                        length: task.length,
                        lengthDisplay: task.lengthDisplay,
                        importanceLevel: task.importanceLevel,
                        startAt: minStart,
                        endAt: minStart + task.length,
                        arranged: true,
                        isNow: false)!)
                    print("Task \(task.name) is added 4")
                    indexScheduled += 1
                }
                
                if(indexScheduled >= 0){
                    var arrayStartTime: [Int] = []
                    var arrayEndTime: [Int] = []
                    for i in 1..<scheduledTasks[indexScheduled].startAt {
                        if i * 5 < scheduledTasks[indexScheduled].startAt{
                            arrayStartTime.append(i * 5)
                        }
                        else {
                            break
                        }
                    }
                    //arrayStartTime.append(scheduledTasks[indexScheduled].startAt) //append here won't do anything, append in result
                    //print(arrayStartTime)
                    for i in 1...scheduledTasks[indexScheduled].endAt {
                        if i * 5 < scheduledTasks[indexScheduled].endAt {
                            arrayEndTime.append(i * 5)
                        }
                        else {
                            break
                        }
                    }
                    arrayEndTime.append(scheduledTasks[indexScheduled].endAt)
                    //print(arrayEndTime)
                    
                    //print("arrayStartTime \(arrayStartTime)")
                    //print("arrayEndTime \(arrayEndTime)")
                    
                    var result = Array(Set(arrayEndTime).subtracting(Set(arrayStartTime))) as [Int]
                    result.append(scheduledTasks[indexScheduled].startAt)
                    result.sort()
                    //print("Result \(result)")
                    
                    for i in 0..<result.count {
                        usedMinuteth.append(result[i])
                    }
                    //print("usedMinuteth \(usedMinuteth)")
                    
                    usedMinuteth = Array(Set(usedMinuteth))
                    usedMinuteth.sort()
                    //print("usedMinuteth \(usedMinuteth)")
                    
                }
            }
            
            
        }
    }
    
}
