//
//  OCWebResultJSonHandler.swift
//
//  Created by oceannw on 15/10/29.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

class OCWebResultJSonHandler: NSObject , OCWebResultHandlerProtocol {
    
    func handler(data : NSData?)throws -> NSDictionary{
        if data == nil {
            return NSDictionary()
        }
        if let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary{
            return result
        }else{
            return NSDictionary()
        }
    }
}