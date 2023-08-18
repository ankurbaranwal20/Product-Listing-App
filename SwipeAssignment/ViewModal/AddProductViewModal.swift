//
//  AddProductViewModal.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import Foundation
import UIKit

enum TableRows:Int, CaseIterable{
    case name
    case type
    case price
    case tax
    case image
}

class AddProductViewModal{
    var addProduct: Product = Product(image: "", price: "", productName: "", productType: "", tax: "")
    
    var errorMsg: String?
    
    func updateData(completion: @escaping () -> Void){
        print(self.addProduct)
        var param = [String: Any]()
        param["product_name"] = self.addProduct.productName
        param["product_type"] = self.addProduct.productType
        param["price"] = self.addProduct.price
        param["tax"] = self.addProduct.tax
        
        HTTPManager.shared.uploadImage(image: self.addProduct.uploadImage ?? UIImage(), param: param) { (error) in
            if let error = error {
                print("Upload error: \(error)")
            } else {
                print("Upload successful")
                completion()
            }
        }
    }
    
    func validateFields() -> Bool{
        guard self.addProduct.productName != "" else{
            errorMsg = "Please enter product name"
            return false
        }
        guard self.addProduct.productType != "" else{
            errorMsg = "Please select product type from dropdown"
            return false
        }
        guard self.addProduct.price != "" else{
            errorMsg = "Price can not be empty"
            return false
        }
        guard self.addProduct.tax != "" else{
            errorMsg = "Please enter tax amount"
            return false
        }
        
        return true
    }
}
