//
//  ScheduledTableViewController.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/23/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit
import UserNotifications

class ScheduledTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    
    //MARK: Outlets
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    
    
    
    
    
    //MARK: Properties
    
    var tasks = [Tasks]()
    var scheduledTasks = [ScheduledTasks]()
    var cantArrangeTask = [ScheduledTasks]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredTasks = [ScheduledTasks]()
    
    //MARK: Actions
    
    //MARK: Private Methods
    
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
    
    private func scheduleTask() {
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
    
    
    
    //MARK: Default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
        //For search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Exact", "Smart"]
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //Load saved tasks
        loadSavedTasks()
        
        scheduleTask() //Organize all tasks
        
        sortTaskByAlphabet() //After have caculated scheduledTask due to using scheduledTask
        
        sortTaskByTime() //Organize all scheduled task by time
        
        sortTaskByArranged() // Then orgnize by succesully arranged
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleNotification()
        
        getIndexOfCurrentTask()
        
        //Burger side menu bar
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    //MARK: Search
    
    //MARK: Search
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTasks = scheduledTasks.filter { scheduledTask in
            let categoryMatch = (scope == "Exact")
            if categoryMatch {
                return scheduledTask.name.lowercased()[0..<searchText.characters.count].contains(searchText.lowercased())
            }
            else {
                return scheduledTask.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Local Notification
    
    func scheduleNotification() {
        
        for scheduledTask in 0..<scheduledTasks.count {
            let monTask = scheduledTasks[scheduledTask]
            
            let contentStart = UNMutableNotificationContent()
            contentStart.title = "Time for \(monTask.name) pal."
            contentStart.subtitle = "Ready pal? Time to get the work done"
            contentStart.body = "Start this task: '\(monTask.name)' now and finish it at \(monTask.endAt[monTask.endAt])"
            contentStart.badge = 1
            //contentStart.categoryIdentifier = "answerCategory"
            //Don't need answer
            contentStart.sound = UNNotificationSound.default()
            
            //if let attachment = try? UNNotificationAttachment(identifier: monTask.name, url: monTask.photo, options: nil) {
            //    contentStart.attachments = [attachment]
            //}
            
            let date = NSDate()
            let calendar = NSCalendar.current
            let hours = calendar.component(.hour, from: date as Date)
            let minutes = calendar.component(.minute, from: date as Date)
            let seconds = calendar.component(.second, from: date as Date)
            
            /*
             let startTime = monTask.startAt[monTask.startAt]
             let minute = Int(startTime[3...4])!
             let period = startTime[6...7]
             var hour: Int
             if period.lowercased() == "am" {
             hour = Int(startTime[0...1])!
             }
             else {
             hour = Int(startTime[0...1])! + 12
             }
             */
            
            let secondToTriggerStart = (monTask.startAt * 5 * 60) - (hours * 3600 + minutes * 60 + seconds)
            
            //print(TimeInterval(secondToTriggerStart))
            
            if secondToTriggerStart >= 0 {
                let notifyDate = Date(timeIntervalSinceNow: TimeInterval(secondToTriggerStart))
                let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notifyDate)
                //let abc = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date(timeIntervalSinceNow: 0))
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                
                let requestIdentifier = monTask.name.replacingOccurrences(of: " ", with: "")
                
                let request = UNNotificationRequest(identifier: requestIdentifier, content: contentStart, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    //print("Uh oh! We had an error: \(error) with task: \(monTask.name)")
                })
                print("Noti to start task: \(monTask.name) supposed to be set now if no error")
                
                
                
                
                
                
                let contentStop = UNMutableNotificationContent()
                contentStop.title = "BREAK TIME!!!"
                contentStop.subtitle = "Still working on this: \(monTask.name)? Time to take a rest."
                if scheduledTasks.count - 1 == scheduledTasks.index(of: monTask) {
                    contentStop.body = "Congratulation pal. The Everest is almost there, just one last task"
                }
                else{
                    contentStop.body = "Congratulation pal. But don't settle cause our next task will begin after: \((scheduledTasks[scheduledTask + 1].startAt - monTask.endAt) * 5) minutes."
                }
                
                contentStop.badge = 1
                contentStop.categoryIdentifier = "answerCategory"
                contentStop.sound = UNNotificationSound.default()
                
                let secondToTriggerStop = (monTask.endAt * 5 * 60) - (hours * 3600 + minutes * 60 + seconds)
                if secondToTriggerStop >= 0 {
                    let notifyDate = Date(timeIntervalSinceNow: TimeInterval(secondToTriggerStop))
                    let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notifyDate)
                    //let abc = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date(timeIntervalSinceNow: 0))
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    
                    let requestIdentifier = monTask.name.replacingOccurrences(of: " ", with: "_")
                    
                    let request = UNNotificationRequest(identifier: requestIdentifier, content: contentStart, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                        //print("Uh oh! We had an error: \(error) with task: \(monTask.name)")
                    })
                    print("Noti to stop task: \(monTask.name) supposed to be set now if no error")
                }
                
                
            }
            
            
        }
        
        
        /*
         UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
         //Remove all and set from the beginning
         
         
         let content = UNMutableNotificationContent()
         content.title = "Pop Quiz!"
         content.subtitle = " Let's see how smart u are!"
         content.body = "How many countries are there in Africa"
         content.badge = 1
         content.categoryIdentifier = "answerCategory"
         content.sound = UNNotificationSound.default()
         
         let url = Bundle.main.url(forResource: "meal1", withExtension: ".png")
         
         if let attachment = try? UNNotificationAttachment(identifier: "africaQuiz", url: url!, options: nil) {
         content.attachments = [attachment]
         }
         
         let date = Date(timeIntervalSinceNow: 5)
         let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
         
         let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
         repeats: false)
         
         let requestIdentifier = "africaQuiz"
         let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
         UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
         print("Uh oh! We had an error: \(error)")
         })
         */
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("There are \(tasks.count) tasks")
        //print("Successfully tasks: \(scheduledTasks.count)")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredTasks.count
        }
        return scheduledTasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScheduledTasksTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScheduledTasksTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScheduledTasksTableViewCell.")
        }
        
        var scheduledTask = scheduledTasks[indexPath.row]
        
        if searchController.isActive && searchController.searchBar.text != "" {
            scheduledTask = filteredTasks[indexPath.row]
        } else {
            //OK
        }
        
        cell.nameLabel.text = scheduledTask.name
        cell.photoImageView.image = scheduledTask.photo
        cell.lengthLabel.text = scheduledTask.lengthDisplay.replacingOccurrences(of: "Length: ", with: "")
        cell.timeLabel.text = "From \(scheduledTask.startAt[scheduledTask.startAt]) to \(scheduledTask.endAt[scheduledTask.endAt])"
        if scheduledTask.arranged == false {
            cell.contentView.backgroundColor = UIColor(red: 6, green: 79, blue: 64)
            cell.backgroundColor = UIColor(red: 6, green: 79, blue: 64)
            print("no")
        }
        if scheduledTask.isNow == true {
            cell.contentView.backgroundColor = UIColor.blue
            cell.backgroundColor = UIColor.blue
            print("Now is \(scheduledTask.name)")
        }
        
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension UITableViewController: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch  response.actionIdentifier {
        case "answerOK":
            let alert = UIAlertController(title: "Congratulation!", message: "Take a rest cause I'm sure the next task is waiting now.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Rest time pal", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        case "answer5More":
            let alert = UIAlertController(title: "Are you SURE?", message: "Work more if you need and turn the phone to vibrate mode.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Thanks pal", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        default:
            print("error")
            break
        }
        UIApplication.shared.applicationIconBadgeNumber = 0 //Clear badges
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Some other way of handing notification in app
        completionHandler([.alert, .sound])
    }
}


