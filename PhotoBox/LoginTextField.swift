//
//  LoginTextField.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/17/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let darkGrayBorder: UIColor = UIColor(displayP3Red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
        self.layer.borderWidth = 3
        self.layer.borderColor = darkGrayBorder.cgColor
        self.layer.cornerRadius = 5
    }
}
