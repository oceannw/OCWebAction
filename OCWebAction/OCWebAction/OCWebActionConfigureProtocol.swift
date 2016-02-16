//
//  OCWebActionConfigureProtocol.swift
//
//  Created by oceannw on 15/10/28.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation
/**
 *  实现与服务器交互功能的参数设置接口
 */
protocol OCWebActionConfigureProtocol{
    /// url地址
    var url:String?{set get}
    /// 提交的参数
    var parameters:[String:String]?{set get}
    /// 表头参数设置
    var headerFields:[String:String]?{set get}
    /// 传送协议
    var httpMethod:OCHTTPMethod{set get}
    /// 编码方式
    var encodeInt:UInt{set get}
    /// Multipart/form-data设置
    var multipartFormData:OCMultipartFormDataProtocol?{set get}
    /// 该接口具体输入信息的描述内容
    var infoMessage:String{get}
    /// 返回结果的数据类型
    var resultType:OCWebActionResultType{set get}
    /**
     返回数据转换为实体类
     :param: 经处理后的数据字典
     :returns: 实现OCTransferableProtocol的实体类
     */
    func transfer(dictionary : NSDictionary) -> OCTransferableProtocol
}

class OCDefaultWebActionConfigure : OCWebActionConfigureProtocol{
    var url:String? = nil
    var parameters:[String:String]? = nil
    var headerFields:[String:String]? = nil
    var httpMethod:OCHTTPMethod = OCHTTPMethod.Post
    var encodeInt:UInt = NSUTF8StringEncoding
    var multipartFormData:OCMultipartFormDataProtocol? = nil
    var resultType:OCWebActionResultType = .JSON
    var infoMessage:String {
        var result  = ""
        if let p = parameters{
            for (key,value) in p{
                result += "\(key):\(value);"
            }
            return result
        }else{
            return "无参数形式操作"
        }
    }
    
    /**
     返回数据转换为实体类，默认返回nil
     :param: result 返回数据，可以为json、xml等形式
     :returns: 实现OCTransferableProtocol的实体类
     */
    func transfer(dictionary: NSDictionary) -> OCTransferableProtocol{
        if OCWebActionManager.enableLog{
            NSLog("WebAction默认transfer的输入数据preTransferedResult:%@", dictionary)
        }
        return OCTransferableNilObject()
    }
}

enum OCWebActionResultType {
    case JSON
    case XML
    func getResultHandler() -> OCWebResultHandlerProtocol{
        switch self{
        case .JSON:
            return OCWebResultJSonHandler()
        case .XML:
            return OCWebResultXMLHandler()
        }
    }
}