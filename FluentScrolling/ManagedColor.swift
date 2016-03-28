//
//  ManagedColor.swift
//  FluentScrolling
//
//  Created by Aleš Kocur on 28/03/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit
import CoreData

class ManagedColor: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}

extension ManagedColor {
    func toColor() -> Color {
        let r = CGFloat(self.r?.floatValue ?? 0.0) / 255.0
        let g = CGFloat(self.g?.floatValue ?? 0.0) / 255.0
        let b = CGFloat(self.b?.floatValue ?? 0.0) / 255.0
        let value = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        return Color(name: self.name ?? "", value: value)
    }
}
