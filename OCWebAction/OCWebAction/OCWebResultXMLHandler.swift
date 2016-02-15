//
//  OCWebResultXMLHandler.swift
//
//  Created by oceannw on 15/10/29.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

class OCWebResultXMLHandler:NSObject , OCWebResultHandlerProtocol {
    
    func handler(data : NSData?)throws -> NSDictionary{
        if data == nil {
            return NSDictionary()
        }
        return NSDictionary()
    }
}