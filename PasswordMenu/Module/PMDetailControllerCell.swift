//
//  PMDetailControllerCell.swift
//  PasswordMenu
//
//  Created by DaiFengyi on 15/11/20.
//  Copyright © 2015年 DaiFengyi. All rights reserved.
//
/**
*   为什么不用accessoryView，因为在edit的状态下，accessoryView会被替换成移动的icon，所以坚持自己加rightButton
    通过cell的edit来控制cell的各种形态不是个很好的注意，定制化太高，code很敏感，还是应该在数据源中设置type或者edit标签来控制
*/
import UIKit
import SnapKit
class PMDetailControllerCell: UITableViewCell , UITextFieldDelegate {
    weak var superController: PMDetailController?
    var rightButtonHidden = false
    /**
     *
     通过ele的didSet来实现自定义类型cell
     */
    var ele: Element? {
        didSet {
            if let lt = ele?.leftText {
                leftField.text = "\(lt)"
            }
            if let rt = ele?.rightText {
                rightField.text = "\(rt)"
            }
            switch ele!.type {
            case "text":
                rightButton.hidden = true
                rightButton.snp_updateConstraints(closure: { (make) -> Void in
                    make.width.equalTo(0)
                })
                rightButtonHidden = true
            case "password":
                rightField.keyboardType = UIKeyboardType.ASCIICapable
                rightField.secureTextEntry = true
            case "date":
                rightButton.setImage(UIImage(named: "QQ"), forState: UIControlState.Normal)
                
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
        if rightButtonHidden {
            return
        }
        if editing {
            rightButton.hidden = false
            rightButton.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(30)
            })
        }else {
            rightButton.hidden = true
            rightButton.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(0)
            })
        }
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
            ele?.leftText = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }else {
            ele?.rightText = textField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
}
