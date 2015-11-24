//
//  PMDetailControllerCell.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/20.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMDetailControllerCell: UITableViewCell , UITextFieldDelegate {
    var ele: Element? {
        didSet {
            if let lt = ele?.leftText {
                leftLabel.text = "\(lt)"
            }
            if let rt = ele?.rightText {
                rightField.text = "\(rt)"
            }
        }
    }
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - TextField 
    func textFieldDidEndEditing(textField: UITextField) {
        ele?.rightText = textField.text
    }
}
