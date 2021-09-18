//
//  TaskViewController.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/19/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit
import os.log
import GoogleMobileAds

class TaskViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GADBannerViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var suggestedStartTimeLabel: UITextField!
    @IBOutlet weak var suggestedEndTimeLabel: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var banner: GADBannerView!
    
    var task: Tasks?
    
    
    
    //MARK: Default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        suggestedStartTimeLabel.delegate = self
        suggestedEndTimeLabel.delegate = self
        
        banner.delegate = self
        
        banner.adUnitID = "ca-app-pub-3879880365186068/3098744836"
        banner.rootViewController = self
        banner.load(GADRequest())
        
        
        // Set up views if editing an existing Task.
        if let task = task {
            navigationItem.title = task.name.uppercased()
            nameTextField.text   = task.name
            photoImageView.image = task.photo
            sliderOutlet.value = Float(task.length)
            lengthLabel.text = "Length: \(task.lengthDisplay)"
            segmentControl.selectedSegmentIndex = task.importanceLevel
            suggestedStartTimeLabel.text = task.openFrom[task.openFrom]
            suggestedEndTimeLabel.text = task.endAt[task.endAt]
        }
        
        
        //Update the lengthLabel to match the slider
        updateSlider()
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Admob
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        banner.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        banner.isHidden = true
    }
    
    
    
    
    
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddTaskMode = presentingViewController is UINavigationController
        
        if isPresentingInAddTaskMode {
            print("yep TaskViewController")
            
            //Return to TaskTableViewController
            //present(TaskTableViewController, animated: true, completion: nil)

            
            //dismiss(animated: true, completion: nil)
            //The dismiss(animated:completion:) method dismisses the modal scene and animates the transition back to the previous scene (in this case, the meal list). The app does not store any data when the meal detail scene is dismissed, and neither the prepare(for:sender:) method nor the unwind action method are called.
        }
        else if let owningNavigationController = navigationController{
            print("no TaskViewController")
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The TaskViewController is not inside a navigation controller.")
        }
    }
    
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let length = Int(sliderOutlet.value)
        let lengthDisplay = lengthLabel.text ?? ""
        let importanceLevel = segmentControl.selectedSegmentIndex
        let openFrom = suggestedStartTimeLabel.text![suggestedStartTimeLabel.text!]
        let endAt = suggestedEndTimeLabel.text![suggestedEndTimeLabel.text!]
        let enabled = true
        
        //case "Strict": importanceLevel = 0
        //case "Compulsory": importanceLevel = 1
        //case "Optional": importanceLevel = 2
        //default: print("Can't detect importance level of task")
        
        // Set the task to be passed to TasksTableViewController after the unwind segue.
        task = Tasks(name: name, photo: photo, length: length, lengthDisplay: lengthDisplay, importanceLevel: importanceLevel, openFrom: openFrom, endAt: endAt, enabled: enabled) //Fix this
    }
    
    
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    var lengthTask = 0
    @IBAction func sliderAction(_ sender: UISlider) {
        updateSlider()
    }
    
    
    //MARK: Private methods
    func updateSlider() {
        lengthTask = Int(sliderOutlet.value)
        let hours = lengthTask * 5 / 60
        let minutes = (lengthTask - hours * 60 / 5) * 5
        if(hours == 0){
            lengthLabel.text = "Length: \(minutes) minutes"
        }
        else if (minutes == 0){
            lengthLabel.text = "Length: \(hours) hours"
        }
        else {
            lengthLabel.text = "Length: \(hours) hours \(minutes) minutes"
        }
    }
    
    func isDigit(str: String) -> Bool {
        let length = str.characters.count
        var digit: Int = 0
        for key in str.unicodeScalars {
            if NSCharacterSet.decimalDigits.contains(key) {
                digit += 1
            }
        }
        if(digit == length){ return true}
        else {return false}
    }
    
    func isTimeDigit(str: String) -> Bool {
        let hour: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        let minute: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
        let length = str.characters.count
        var digit: Int = 0
        for key in str.unicodeScalars {
            if NSCharacterSet.decimalDigits.contains(key) {
                digit += 1
            }
        }
        if(digit == length){
            if hour.contains(Int((suggestedStartTimeLabel.text?[0...1])!)!) && hour.contains(Int((suggestedEndTimeLabel.text?[0...1])!)!) && minute.contains(Int((suggestedStartTimeLabel.text?[3...4])!)!) && minute.contains(Int((suggestedEndTimeLabel.text?[3...4])!)!){
                return true
            }
            else{
                return false
            }
        }
        else {
            return false
        }
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        var hourStart = suggestedStartTimeLabel.text?[0...1] ?? ""
        var minuteStart = suggestedStartTimeLabel.text?[3...4] ?? ""
        var periodStart = suggestedStartTimeLabel.text?[6...7] ?? ""
    
        var hourEnd = suggestedEndTimeLabel.text?[0...1] ?? ""
        var minuteEnd = suggestedEndTimeLabel.text?[3...4] ?? ""
        var periodEnd = suggestedEndTimeLabel.text?[6...7] ?? ""
        
        if !isDigit(str: hourStart) { hourStart = "" }
        if !isDigit(str: hourEnd) {hourEnd = ""}
        if !isDigit(str: minuteStart) {minuteStart = "" }
        if !isDigit(str: minuteEnd) {minuteEnd = "" }
        
        if periodEnd.uppercased() != "PM" && periodEnd.uppercased() != "AM" {
            periodEnd = ""
        }
        if periodStart.uppercased() != "PM" && periodStart.uppercased() != "AM" {
            periodStart = ""
        }
        
        let textStart = suggestedStartTimeLabel.text ?? ""
        let textEnd = suggestedEndTimeLabel.text ?? ""
        let text = nameTextField.text ?? ""
        
        saveButton.isEnabled = !text.isEmpty && !textStart.isEmpty && !textEnd.isEmpty && !hourStart.isEmpty && !hourEnd.isEmpty && !minuteStart.isEmpty && !(minuteEnd.isEmpty) && !periodStart.isEmpty && !(periodEnd.isEmpty)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if textField.placeholder == "Enter activity name" {
            navigationItem.title = textField.text?.uppercased()
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
