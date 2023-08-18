//
//  ProductListViewCell.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import UIKit
import Kingfisher

class ProductListViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: Product){
        self.productImage.layer.cornerRadius = 8.0
        
        self.titleLabel.text = data.productName
        self.typeLabel.text = data.productType
        self.priceLabel.text = "\(data.price)"
        if data.tax != "0.0"{
            self.taxLabel.text = "\(data.tax)"
        }else{
            self.taxLabel.text = ""
        }
        
        
        self.productImage.kf.indicatorType = .activity
        self.productImage.kf.setImage(with: URL(string: data.image),placeholder: UIImage(systemName: "photo"))
        
    }
    
}
