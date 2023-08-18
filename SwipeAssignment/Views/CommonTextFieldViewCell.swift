//
//  CommonTextFieldViewCell.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import UIKit

protocol TextFieldDelegate: AnyObject{
    func textFieldEndEditing(textFieldData: String, rowIndex: Int)
}

class CommonTextFieldViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: TextFieldDelegate?
    var pickerView: UIPickerView?
    var toolBar = UIToolbar()
    var rowIndex = -1
    var selectedtypeIndex = 0
    
    var pickerData = ["Product","Service"]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUPCell(title: String, description: String,placeholder: String, rowIndex: Int = -1){
        self.titleLabel.text = title
        self.textField.placeholder = placeholder
        self.textField.text = description
        self.rowIndex = rowIndex
        switch TableRows(rawValue: rowIndex){
        case .type:
            setPickerView()
        case .name:
            self.textField.inputView = nil
            self.textField.keyboardType = .default
            setToolBar()
            textField.inputAccessoryView = toolBar
        case .price,.tax:
            self.textField.inputView = nil
            self.textField.keyboardType = .decimalPad
            setToolBar()
            textField.inputAccessoryView = toolBar
        default:
            break
        }
        
    }
    
    func setToolBar(){
        toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(prickerDoneButtonClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func setPickerView() {
        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        setToolBar()
        
        
        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
    
    @objc func prickerDoneButtonClicked() {
        textField.resignFirstResponder()
    }
    
}
extension CommonTextFieldViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldEndEditing(textFieldData: textField.text ?? "", rowIndex: rowIndex)
        textField.resignFirstResponder()
    }
}
extension CommonTextFieldViewCell: UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = self.pickerData[row]
        self.delegate?.textFieldEndEditing(textFieldData: self.pickerData[row], rowIndex: rowIndex)
    }
    
}
