//
//  ProductViewModal.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import Foundation

class ProductViewModal{
    
    var productList: ProductList?
    
    var filteredProduct = [Product](){
        didSet{
            self.refreshTableData?()
        }
    }
    
    var refreshTableData: (() -> ())?
    
    func getProductList(completion: @escaping () -> Void){
        let url = "https://app.getswipe.in/api/public/get"
        
        HTTPManager.shared.getData(urlString: url) { (result) in
            switch result{
            case .success(let data):
                do{
                    if let json = try JSONSerialization.jsonObject(with: data,options: .mutableContainers) as? [[String: Any]]{
                        self.productList = ProductList(json: json)
                        if let list = self.productList{
                            self.filteredProduct = list.products
                        }
                        
                    }
                    completion()
                }catch{
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSearchProduct(searchText: String){
        
        if searchText.isEmpty{
            self.filteredProduct = self.productList!.products
        }else{
            self.filteredProduct = self.productList!.products.filter({ (product:Product) -> Bool in
                let name = product.productName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return name != nil
            })
        }
        
    }
    
    func getImageData(url: String,compeltion: @escaping (Data) -> Void){
        
        HTTPManager.shared.getData(urlString: url) { (result) in
            switch result{
            case .success(let data):
                compeltion(data)
            
            case .failure(let error):
                print("Error - \(error.localizedDescription)")
            }
        }
        
    }
}
