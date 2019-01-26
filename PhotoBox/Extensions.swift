//
//  Extensions.swift
//  PhotoBox
//
//  Created by Jack Knight on 1/24/19.
//  Copyright © 2019 Cameron Milliken. All rights reserved.
//

import Foundation

extension Date {
    
    func formattedString() -> String {
//
//        let dateComponents = Calendar.current.dateComponents([.month, .year], from: self)
//
//        let dateComponentsFormatter = DateComponentsFormatter()
//        dateComponentsFormatter.allowedUnits = [.month, .year]
//        return dateComponentsFormatter.string(from: dateComponents)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        let dateString = formatter.string(from: self)
        return dateString
    }
}
