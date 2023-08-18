//
//  UploadImageViewCell.swift
//  SwipeAssignment
//
//  Created by Ankur Baranwal on 17/08/23.
//

import UIKit

protocol UploadImageDelegate: AnyObject{
    func selectImage()
}

class UploadImageViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    
    weak var delegate : UploadImageDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUPCell(image: UIImage){
        self.productImage.layer.cornerRadius = 8.0
        if image == UIImage(){
            self.productImage.image = UIImage(systemName: "photo")
        }else{
            self.productImage.image = image
        }
    }
    
    @IBAction func uploadBtnAction(_ sender: Any) {
        self.delegate?.selectImage()
    }
    
}
