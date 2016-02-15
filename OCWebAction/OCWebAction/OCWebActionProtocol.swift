//
//  OCWebActionProtocol.swift
//
//  Created by oceannw on 15/10/28.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

protocol OCWebActionProtocol {
    
    func action(configure:OCWebActionConfigureProtocol,success: (result:OCTransferableProtocol?) -> Void, failure: (error: NSError) -> Void)
}

class OCSynchronousAction:OCWebActionProtocol {
    
    func action(configure:OCWebActionConfigureProtocol,success: (result:OCTransferableProtocol?) -> Void, failure: (error: NSError) -> Void) {
        do{
            let handler:OCWebResultHandlerProtocol = configure.resultType.getResultHandler()
            let connection:OCWebConnectionProtocol = OCSynchronousURLSession()
            let result = try connection.connect(configure, handler: handler)
            success(result: result)
        }catch{
            let errorTemp = error as NSError
            if OCWebActionManager.enableLog{
                NSLog("OCWebAction操作%@失败，输入参数：%@，异常信息：%@", configure.url!,configure.infoMessage ?? "暂无", error as NSError)
            }
            if errorTemp.domain == NSURLErrorDomain{
                failure(error: NSError(domain: NSURLErrorDomain, code: errorTemp.code, userInfo: [kOCWebActionError:"网络异常，稍后再试"]))
            }else{
                failure(error: errorTemp)
            }
        }
    }
}

class OCSynchronousReconnectAction:OCWebActionProtocol {
    /// 网络中断重新连接的次数
    var reconnectCountMax = 3
    private var currentReconnectCount = 0
    func action(configure:OCWebActionConfigureProtocol,success: (result:OCTransferableProtocol?) -> Void, failure: (error: NSError) -> Void) {
        do{
            currentReconnectCount++
            let handler:OCWebResultHandlerProtocol = configure.resultType.getResultHandler()
            let connection:OCWebConnectionProtocol = OCSynchronousURLSession()
            let result = try connection.connect(configure, handler: handler)
            success(result: result)
            currentReconnectCount = 0
        }catch{
            let errorTemp = error as NSError
            if OCWebActionManager.enableLog{
                NSLog("OCWebAction操作%@失败，输入参数：%@，异常信息：%@", configure.url!,configure.infoMessage ?? "暂无", error as NSError)
            }
            if errorTemp.domain == NSURLErrorDomain && self.currentReconnectCount <= self.reconnectCountMax{
                action(configure,success: success, failure: failure)
            }else if errorTemp.domain == NSURLErrorDomain{
                failure(error: NSError(domain: NSURLErrorDomain, code: errorTemp.code, userInfo: [kOCWebActionError:"网络异常，稍后再试"]))
            }else{
                failure(error: errorTemp)
            }
        }
    }
}

class OCAsynchronousAction:OCWebActionProtocol {
    
    func action(configure:OCWebActionConfigureProtocol,success: (result:OCTransferableProtocol?) -> Void, failure: (error: NSError) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let connection:OCWebActionProtocol = OCSynchronousAction()
            connection.action(configure, success: { (result) -> Void in
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    success(result: result)
                })
                }, failure: { (error) -> Void in
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        failure(error: error)
                    })
            })
        })
    }
}