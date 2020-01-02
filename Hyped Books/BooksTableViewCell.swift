//
//  BooksTableViewCell.swift
//  Hyped Books
//
//  Created by Азизбек on 02.01.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var authorLabelOutlet: UILabel!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var annotationLabelOutlet: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
