//
//  OCWebError.swift
//
//  Created by oceannw on 15/10/28.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

let kOCWebErrorDomain = "OCWebConnectionErrorDomain"
let kOCWebActionError = "kOCWebActionError"

enum OCWebError : Int{
    case URLIsNil                           = 10000
    case ParameterEncodingFailure           = 10001
    case FailureToTransfer                  = 10002
    case FailureToPreTransfer               = 10003
    case OriginServerError                  = 10004
    
    static func getErrorDesciption(error : OCWebError) ->String{
        switch error{
        case .URLIsNil:
            return "未设置服务器的URL地址"
        case .ParameterEncodingFailure:
            return "参数编码失败"
        case .FailureToTransfer:
            return "服务器返回数据转化实例失败"
        case .FailureToPreTransfer:
            return "操作失败"
        case .OriginServerError:
            return "服务器错误"
        }
    }
}

