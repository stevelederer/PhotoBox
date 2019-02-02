//
//  UnderlineButtonTextDarkGray.swift
//  PhotoBox
//
//  Created by Steve Lederer on 1/26/19.
//  Copyright © 2019 Steve Lederer. All rights reserved.
//

import UIKit

class UnderlineButtonTextDarkGray: UIButton {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        self.setAttributedTitle(self.attributedString(), for: .normal)
    }
    
    private func attributedString() -> NSAttributedString? {
        let darkGray = UIColor(named: "textDarkGray") ?? .darkGray
        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : darkGray,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        return attributedString
    }
}
