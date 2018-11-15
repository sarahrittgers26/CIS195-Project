//
//  EventTableViewCell.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
