//
//  MondayTasksTableViewCell.swift
//  Smart Calender (Beta)
//
//  Created by QUANG on 12/23/16.
//  Copyright © 2016 Q.U.A.N.G. All rights reserved.
//

import UIKit

class ScheduledTasksTableViewCell: UITableViewCell {
    
    
    var mondayTask: ScheduledTasks! {
        didSet {
            self.updateUI()
        }
    }
    
    
    //MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!    
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    
    
    
    //MARK: Private Methods
    func updateUI() {
        backgroundCardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.init(red: 55/255.0, green: 139/255.0, blue: 128/255.0, alpha: 1.0)
        
        backgroundCardView.layer.cornerRadius = 4.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
