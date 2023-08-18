//
//  Product.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import Foundation
import UIKit

class Product {
    var image: String
    var price: String
    var productName: String
    var productType: String
    var tax: String
    var uploadImage: UIImage?
    
    init(image: String, price: String, productName: String, productType: String, tax: String) {
        self.image = image
        self.price = price
        self.productName = productName
        self.productType = productType
        self.tax = tax
    }
}

class ProductList{
    var products = [Product]()
    
    init(json: [[String:Any]]){
        for item in json {
            if let image = item["image"] as? String,
               let price = item["price"] as? Double,
               let productName = item["product_name"] as? String,
               let productType = item["product_type"] as? String,
               let tax = item["tax"] as? Double {
                let product = Product(image: image, price: "\(price)", productName: productName, productType: productType, tax: "\(tax)")
                products.append(product)
            }
        }
    }
}
