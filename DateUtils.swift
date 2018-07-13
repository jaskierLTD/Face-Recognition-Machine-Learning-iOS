//
//  DateUtils.swift
//  GetMeSocial
//
//  Created by Iorweth on 28/06/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Foundation

extension Date
{
    // Date System Formatted Medium
    func ToDateMediumString() -> NSString?
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium;
        formatter.timeStyle = .none;
        return formatter.string(from: self) as NSString
    }
}
