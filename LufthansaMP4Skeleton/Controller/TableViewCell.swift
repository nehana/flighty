//
//  TableViewCell.swift
//  LufthansaMP4Skeleton
//
//  Created by Neha Nagabothu on 3/4/19.
//  Copyright © 2019 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var tablePlaneImg : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tablePlaneImg = UIImageView(frame: CGRect(x: 10, y: contentView.frame.height / 2, width: 100, height: 100))
        
        tablePlaneImg.contentMode = .scaleAspectFit
        contentView.addSubview(tablePlaneImg)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

