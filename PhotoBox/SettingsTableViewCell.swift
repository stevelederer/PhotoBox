//
//  SettingsTableViewCell.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/23/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "buttonGreen")
        self.selectedBackgroundView = bgColorView
    }

}
