//
//  TaskTableViewController.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/20/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit
import os.log

class TaskTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    //MARK: Outlets
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    
    //MARK: Properties
    
    var tasks = [Tasks]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredTasks = [Tasks]()
    
    
    //MARK: Actions
    
    @IBAction func PrintCalender(_ sender: UIBarButtonItem) {
        saveTasks()
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TaskViewController, let task = sourceViewController.task {
            
            print("yep")
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //This code checks whether a row in the table view is selected. If it is, that means a user tapped one of the table views cells to edit a task. In other words, this if statement gets executed when you are editing an existing task.
                // Update an existing task
                tasks[selectedIndexPath.row] = task
                
                tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
                
            }
            else {
                
                // Add a new task.
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                
                tasks.append(task)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the tasks.
            saveTasks()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleTasks() {
        let photo1 = UIImage(named: "task1")
        let photo2 = UIImage(named: "task2")
        let photo3 = UIImage(named: "task3")
        
        
        guard let task1 = Tasks(name: "Do Homework", photo: photo1, length: 12, lengthDisplay: "1 hours", importanceLevel: 0, openFrom: 96, endAt: 132, enabled: true) else {
            fatalError("Unable to instantiate task1")
        }
        
        guard let task2 = Tasks(name: "Jym", photo: photo2, length: 24, lengthDisplay: "2 hours", importanceLevel: 1, openFrom: 228, endAt: 240, enabled: true) else {
            fatalError("Unable to instantiate task2")
        }
        
        
        guard let task3 = Tasks(name: "Sleep", photo: photo3, length: 6, lengthDisplay: "30 minutes", importanceLevel: 2, openFrom: 132, endAt: 144, enabled: true) else {
            fatalError("Unable to instantiate task3")
        }
        
        tasks += [task1, task2, task3]
    }
    
    
    private func saveTasks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tasks, toFile: Tasks.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Tasks successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save tasks...", log: OSLog.default, type: .error)
        }
    }
    
    
    private func loadTasks() -> [Tasks]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Tasks.ArchiveURL.path) as? [Tasks]
    }
    
    private func sortTaskByEnability() {
        var result = [Tasks]()
        for index in 0..<tasks.count {
            if tasks[index].enabled == true {
                result.append(tasks[index]) //These first tasks will lie at the the end of the table view
            }
        }
        for index in 0..<tasks.count {
            if tasks[index].enabled == false {
                result.append(tasks[index]) //These last tasks will lie at the the top of the table view
            }
        }
        tasks = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //For search
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Exact", "Smart"]
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItems?[1] = editButtonItem
        editButtonItem.tintColor = UIColor(red: 225, green: 225, blue: 0)

        
        // Load any saved tasks, otherwise load sample data.
        if let savedTasks = loadTasks() {
            tasks += savedTasks
        }
        else{
            // Load the sample data.
            loadSampleTasks()
        }
        
        sortTaskByEnability() //Organize task by enability
        
        
        //Burger side menu bar
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Search
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredTasks = tasks.filter { task in
            let categoryMatch = (scope == "Exact")
            if categoryMatch {
                return task.name.lowercased()[0..<searchText.characters.count].contains(searchText.lowercased())
            }
            else {
                return task.name.lowercased().contains(searchText.lowercased())
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
    
    
    
    
    
    
    // MARK: - Table view data source
    
    /*
     override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     
     return self.section[section]
     
     }
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredTasks.count
        }
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TasksTableViewCell"
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TasksTableViewCell  else {
            fatalError("The dequeued cell is not an instance of TasksTableViewCell.")
        }
        
        var task = tasks[indexPath.row]
        
        if searchController.isActive && searchController.searchBar.text != "" {
            task = filteredTasks[indexPath.row]
        } else {
            //OK
        }
        
        cell.nameLabel.text = task.name
        cell.photoImageView.image = task.photo
        cell.lengthLabel.text = task.lengthDisplay.replacingOccurrences(of: "Length: ", with: "")
        cell.enabledLabel.text = task.enabled == true ? "Enabled" : "Disabled"
        print(task.name)
        print(task.enabled)
        if task.enabled == false {
            cell.contentView.backgroundColor = UIColor(red: 6, green: 79, blue: 64)
            cell.backgroundColor = UIColor(red: 6, green: 79, blue: 64)
            print("no")
        }
        else {
            cell.contentView.backgroundColor = UIColor(red: 55, green: 139, blue: 128)
            cell.backgroundColor = UIColor(red: 55, green: 139, blue: 128)
        }
        
        // Configure the cell...
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = tasks[indexPath.row]
        
        let enable = UITableViewRowAction(style: .normal, title: task.enabled == true ? "Disable" : "Enable") { action, index in
            print("enable button tapped")
            if task.enabled == true {
                task.enabled = false
            }
            else {
                task.enabled = true
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
            tableView.endUpdates()
            self.saveTasks()
        }
        enable.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.tasks.remove(at: self.tasks.index(of:task)!)
            tableView.deleteRows(at: [indexPath], with: .left)
            self.saveTasks()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, enable]
    }
    
    /*
     override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 45.0
     }
     
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     var sectionHeaderView: UIView
     sectionHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 120.0))
     
     sectionHeaderView.backgroundColor = UIColor(red: 0, green: 0, blue: 0);
     
     var headerLabel: UILabel
     headerLabel = UILabel.init(frame: CGRect(x: sectionHeaderView.frame.origin.x, y: sectionHeaderView.frame.origin.y - 38, width: sectionHeaderView.frame.size.width, height: sectionHeaderView.frame.size.height))
     
     headerLabel.backgroundColor = UIColor.clear;
     //headerLabel.textColor = UIColor(red: 255, green: 255, blue: 255)
     headerLabel.textAlignment = NSTextAlignment.center
     headerLabel.font = UIFont(name: "Mono", size: 20)
     sectionHeaderView.addSubview(headerLabel)
     
     switch section
     {
     case 0:
     headerLabel.textColor = UIColor(red: 83, green: 177, blue: 84)
     headerLabel.text = "Strict Tasks"
     return sectionHeaderView;
     case 1:
     headerLabel.textColor = UIColor(red: 56, green: 161, blue: 224)
     headerLabel.text = "Compulsory Tasks"
     return sectionHeaderView;
     case 2:
     headerLabel.textColor = UIColor(red: 194, green: 67, blue: 134)
     headerLabel.text = "Optional Tasks"
     return sectionHeaderView;
     default:
     headerLabel.text = "Unknown"
     return sectionHeaderView;
     }
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.tasks[fromIndexPath.row]
        
        //When done arranging, change cell value of importanceLevel
        //tasks[fromIndexPath.row].importanceLevel = tasks[destinationIndexPath.row].importanceLevel
        
        //movedObject.importanceLevel = destinationIndexPath.section
        
        tasks.remove(at: fromIndexPath.row)
        tasks.insert(movedObject, at: destinationIndexPath.row)
        
        saveTasks()
        
        NSLog("%@", "\(fromIndexPath.row) => \(destinationIndexPath.row): \(tasks[fromIndexPath.row].name)")
        // To check for correctness enable: self.tableView.reloadData()
    }
 */
    
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new task.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let taskDetailViewController = segue.destination as? TaskViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTaskCell = sender as? TasksTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            var selectedTask = tasks[indexPath.row]
            if searchController.isActive && searchController.searchBar.text != "" {
                selectedTask = filteredTasks[indexPath.row]
            } else {
                selectedTask = tasks[indexPath.row]
            }
            taskDetailViewController.task = selectedTask
            
        case "PrintCalender":
            os_log("Printing caculated calender", log: OSLog.default, type: .debug)
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
}
