//
//  StudyGroupTableViewCell.swift
//  StudyConnect
//
//  Created by Sarah Rittgers on 11/14/18.
//  Copyright © 2018 Sarah Rittgers. All rights reserved.
//

import UIKit

class StudyGroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var professor: UILabel!
    @IBOutlet weak var section: UILabel!
    @IBOutlet weak var members: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
