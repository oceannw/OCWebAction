//
//  OCWebResultHandlerProtocol.swift
//
//  Created by oceannw on 15/10/29.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

protocol OCWebResultHandlerProtocol{
    func handler(data : NSData?)throws -> NSDictionary
}