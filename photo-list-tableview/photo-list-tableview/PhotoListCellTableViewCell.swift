//
//  PhotoListCellTableViewCell.swift
//  photo-list-tableview
//
//  Created by Mark bergeson on 7/11/21.
//

import UIKit

class PhotoListCellTableViewCell: UITableViewCell {

    @IBOutlet weak var photoListImage: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    // this func will help with photos flip flopping
    //always include it!!
    override func prepareForReuse() {
        super.prepareForReuse()
        photoListImage.image = nil
        bottomLabel.text = nil
        topLabel.text = nil
    }
    
    func configure(photoList: PhotoList?) {
        guard let photoList = photoList else {
            photoListImage.image = nil
            bottomLabel.text = nil
            topLabel.text = nil
            return
        }
        API.shared.getImage(urlString: photoList.urls.regular) { (data) in
            guard let data = data else {
                self.photoListImage.image = nil
                return
            }
            let image = UIImage(data: data)
            self.photoListImage.image = image
            
        }
        
        topLabel.text = photoList.alt_description
        bottomLabel.text = photoList.created_at
    }


}
