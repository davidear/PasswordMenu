//
//  PMDetailControllerCell.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/20.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//

import UIKit

class PMDetailControllerCell: UITableViewCell , UITextFieldDelegate {
    weak var superController: PMDetailController?
    var ele: Element? {
        didSet {
            if let lt = ele?.leftText {
                leftField.text = "\(lt)"
            }
            if let rt = ele?.rightText {
                rightField.text = "\(rt)"
            }
            switch ele!.type {
            case "password":
                rightField.keyboardType = UIKeyboardType.ASCIICapable
                rightField.secureTextEntry = true
            default:
                break
            }
        }
    }
    
    @IBOutlet weak var leftField: UITextField!
    @IBOutlet weak var rightField: UITextField!
    @IBOutlet weak var rightButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //        if editing  {
        //            rightButton.hidden = false
        //        }else {
        //            rightButton.hidden = true
        //        }
    }

    // MARK: - Button action
    @IBAction func rightButtonAction(sender: UIButton) {
        if let passwordGeneratorController = superController?.storyboard?.instantiateViewControllerWithIdentifier("PMPasswordGeneratorController") as? PMPasswordGeneratorController {
            passwordGeneratorController.success = { [unowned self](randomString: String) -> Void in 
                self.ele?.rightText = randomString
                }
            superController?.showViewController(passwordGeneratorController, sender: nil)
        }
    }
    // MARK: - TextField
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == leftField {
            ele?.leftText = textField.text
        }else {
            ele?.rightText = textField.text
        }
    }
}
