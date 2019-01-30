//
//  PaddingTextField.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/29/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import UIKit

class PaddingTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
