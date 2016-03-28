//
//  CellHeightCache.swift
//  FluentScrolling
//
//  Created by Aleš Kocur on 28/03/16.
//  Copyright © 2016 Aleš Kocur. All rights reserved.
//

import UIKit

class CellHeightCache<T: AnyObject> {
    let cache = NSCache()
    
    func heightForObject(object: T) -> CGFloat? {
        return cache.objectForKey(object) as? CGFloat
    }
    
    func setHeightForObject(object: T, height: CGFloat) {
        cache.setObject(height, forKey: object)
    }
    
    init() { }
}