//
//  TableViewCell.swift
//  FluentScrolling
//
//  Created by Aleš Kocur on 28/03/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    static var reuseIdentifier: String {
        return "ColorTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Height calculations
    
    static var preferredEstimatedHeight: CGFloat {
        return 100.0
    }
    
    class func preferredHeightForColor(color: Color, width: CGFloat) -> CGFloat {
        if color.name == "" {
            return 30.0
        } else {
            return 100.0
        }
    }
    
    // Configure with values
    
    func willDisplayWithColor(color: Color) {
        nameLabel.text = color.name
//        nameLabel.backgroundColor = color.value
        backgroundColor = color.value
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        backgroundColor = UIColor.whiteColor()
        
        super.prepareForReuse()
    }
    
}
