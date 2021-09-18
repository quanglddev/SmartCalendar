//
//  TimeControl.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/19/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit

@IBDesignable class TimeControl: UIStackView {
    
    //MARK: Properties
    
    /*
    private var timeButtons = [UIButton]()
    
    var time = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
 
 
    }
     */

    
    //MARK: Button Action

/*
    func timeButtonTapped(button: UIButton) {
        print("Button pressed 👍")
        
        guard let index = timeButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(timeButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == time {
            // If the selected star represents the current rating, reset the rating to 0.
            time = 0
        } else {
            // Otherwise set the rating to the selected star
            time = selectedRating
        }
    }
 */
    
    //MARK: Private Methods
    
    /*
    private func setupButtons() {
        
        // clear any existing buttons
        for button in timeButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        timeButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Setup the button action
            button.addTarget(self, action: #selector(TimeControl.timeButtonTapped(button:)), for: .touchUpInside)
            
            // Add the new button to the rating button array
            timeButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    
    private func updateButtonSelectionStates() {
        for (index, button) in timeButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < time
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if time == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (time) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(time) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
 */
}
