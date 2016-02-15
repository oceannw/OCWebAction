//
//  OCMultipartFormDataProtocol.swift
//
//  Created by oceannw on 15/10/28.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

/// 对MultipartFormData进行封装
protocol OCMultipartFormDataProtocol{
    func multipartFormDataHandler(formData:[NSObject: AnyObject]?)
}