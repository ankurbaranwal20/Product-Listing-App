//
//  AddProductViewController.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import UIKit

class AddProductViewController: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var addViewModal = AddProductViewModal()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        // Do any additional setup after loading the view.
    }
    
    func registerCell(){
        self.tableView.register(UINib(nibName: "CommonTextFieldViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CommonTextFieldViewCell")
        self.tableView.register(UINib(nibName: "UploadImageViewCell", bundle: Bundle.main), forCellReuseIdentifier: "UploadImageViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.submitButton.layer.cornerRadius = 10.0
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if self.addViewModal.validateFields(){
            self.addViewModal.updateData {
                HTTPManager.shared.showAlert(owner: self, message: "Product Uploaded Successfully.") {
                    self.dismiss(animated: true)
                }
            }
        }else{
            HTTPManager.shared.showAlert(owner: self, message: self.addViewModal.errorMsg ?? "") {
                
            }
        }
        
    }
}

extension AddProductViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableRows.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fieldCell = tableView.dequeueReusableCell(withIdentifier: "CommonTextFieldViewCell") as? CommonTextFieldViewCell else{
            return UITableViewCell()
        }
        fieldCell.selectionStyle = .none
        guard let imageCell = tableView.dequeueReusableCell(withIdentifier: "UploadImageViewCell") as? UploadImageViewCell else{
            return UITableViewCell()
        }
        imageCell.selectionStyle = .none
        switch TableRows(rawValue: indexPath.row){
        case .name:
            fieldCell.setUPCell(title: "Product Name", description: addViewModal.addProduct.productName,placeholder: "Enter Product Name",rowIndex: indexPath.row)
            fieldCell.delegate = self
            return fieldCell
        case .type:
            fieldCell.setUPCell(title: "Product Type", description: addViewModal.addProduct.productType,placeholder: "Select Product Type",rowIndex: indexPath.row)
            fieldCell.delegate = self
            return fieldCell
        case .price:
            fieldCell.setUPCell(title: "Product Price", description: "\(addViewModal.addProduct.price)",placeholder: "Enter Product Price",rowIndex: indexPath.row)
            fieldCell.delegate = self
            return fieldCell
        case .tax:
            fieldCell.setUPCell(title: "Product Tax", description: "\(addViewModal.addProduct.tax)",placeholder: "Enter Tax",rowIndex: indexPath.row)
            fieldCell.delegate = self
            return fieldCell
        case .image:
            imageCell.setUPCell(image:(addViewModal.addProduct.uploadImage ?? UIImage()))
            imageCell.delegate = self
            return imageCell
        default:
            return UITableViewCell()
        }
    }
}
extension AddProductViewController: TextFieldDelegate{
    
    func textFieldEndEditing(textFieldData: String, rowIndex: Int) {
        switch TableRows(rawValue: rowIndex){
        case .name:
            addViewModal.addProduct.productName = textFieldData
        case .type:
            addViewModal.addProduct.productType = textFieldData
        case .price:
            addViewModal.addProduct.price = textFieldData
        case .tax:
            addViewModal.addProduct.tax = textFieldData
        default:
            break
        }
        
    }

}
extension AddProductViewController: UploadImageDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func selectImage() {
        showImagePicker(sourceType: .photoLibrary)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                addViewModal.addProduct.uploadImage = selectedImage
                self.tableView.reloadData()
            }
            
        imagePicker.dismiss(animated: true, completion: nil)
        }
}
