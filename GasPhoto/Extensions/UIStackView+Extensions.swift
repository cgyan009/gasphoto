//
//  UIStackView+Extensions.swift
//  GasPhoto
//
//  Created by Chenguo Yan on 2020-02-27.
//  Copyright © 2020 Chenguo Yan. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(text: String, subtext: String) {
        let textlabel = UILabel()
        let subtextLabel = UILabel()
        textlabel.text = text
        subtextLabel.text = subtext
        self.init(arrangedSubviews: [textlabel, subtextLabel])
    }
}
