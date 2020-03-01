//
//  PhotoCell.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-26.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    private enum Constants {
        static let imageViewLength: CGFloat = 48.0
        static let leadingDistance: CGFloat = 16.0
        static let inset: CGFloat = 80.0
        static let zero: CGFloat = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        //adjust the separator distance to `imageView`
        separatorInset = .init(top: Constants.inset,
                               left: Constants.inset,
                               bottom: Constants.zero,
                               right: Constants.zero)
        
        if let imageView = imageView, let textLabel = textLabel {
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewLength),
                imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewLength),
                imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Constants.leadingDistance),
                textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                                   constant: Constants.leadingDistance),
                textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }
}
