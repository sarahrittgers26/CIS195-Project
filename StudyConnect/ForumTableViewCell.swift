//
//  ForumTableViewCell.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/27/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class ForumTableViewCell: UITableViewCell {

    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var school: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
