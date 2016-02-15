//
//  OCWebConnectionProtocol.swift
//
//  Created by oceannw on 15/10/28.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation

protocol OCWebConnectionProtocol{
    func connect(configure:OCWebActionConfigureProtocol , handler:OCWebResultHandlerProtocol)throws -> OCTransferableProtocol
}

class OCSynchronousURLSession: OCWebConnectionProtocol {
    
    private var semphore = dispatch_semaphore_create(0)
    
    func connect(configure:OCWebActionConfigureProtocol , handler:OCWebResultHandlerProtocol)throws -> OCTransferableProtocol{
        let request = try configureDownloadRequest(configure)
        let session = NSURLSession.sharedSession()
        var result:NSData?
        var resultError:NSError?
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if OCWebActionManager.enableLog{
                NSLog("OCWebAction操作接口：%@，返回response响应数据：%@", configure.url! , response ?? "暂无")
                
                if data == nil{
                    NSLog("OCWebAction操作接口：%@，返回内容：%@", configure.url! ,"无返回内容")
                }
                if error != nil{
                    NSLog("OCWebAction操作接口：%@，返回异常：%@", configure.url! ,error!)
                }
            }
            resultError = error
            result = data
            dispatch_semaphore_signal(self.semphore)
        }
        dataTask.resume()
        dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER)
        if resultError != nil{
            throw resultError!
        }
        let resultDictionary = try handler.handler(result)
        if OCWebActionManager.enableLog{
            NSLog("OCWebAction操作接口：%@，返回内容：%@", configure.url! ,resultDictionary)
        }
        let transferedResult = configure.transfer(resultDictionary)
        return transferedResult
    }
    
    /**
     配置NSURLRequest
     
     :param: configure 配置参数
     
     :returns: 配置后的NSURLRequest
     */
    private func configureDownloadRequest(configure:OCWebActionConfigureProtocol)throws ->NSURLRequest{
        switch configure.httpMethod{
        case .Post:
            return try configureDownloadRequestForPost(configure)
        case .Get:
            return try configureDownloadRequestForGet(configure)
        }
    }
    
    private func configureDownloadRequestForPost(configure:OCWebActionConfigureProtocol)throws ->NSURLRequest{
        let url = try handlerURL(configure.url)
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy
            , timeoutInterval: 60)
        request.HTTPMethod = configure.httpMethod.rawValue
        if configure.headerFields != nil{
            for (key,value) in configure.headerFields!{
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        if configure.parameters != nil{
            let mergeParameterString = mergeParatemers(configure.parameters!)
            let mergeParameterData = mergeParameterString.dataUsingEncoding(configure.encodeInt)
            guard mergeParameterData != nil else{
                throw NSError(domain: kOCWebErrorDomain , code: OCWebError.ParameterEncodingFailure.rawValue, userInfo: nil)
            }
            request.HTTPBody = mergeParameterData!
            if OCWebActionManager.enableLog{
                NSLog("OCWebAction操作接口：%@，输出参数：%@", configure.url! , NSString(data: mergeParameterData ?? NSData(), encoding: configure.encodeInt) ?? "解码失败" )
            }
        }
        return request
    }
    
    private func configureDownloadRequestForGet(var configure:OCWebActionConfigureProtocol)throws ->NSURLRequest{
        if configure.parameters != nil{
            let mergeParameterString = mergeParatemers(configure.parameters!)
            if configure.url != nil{
                configure.url! += "?" + mergeParameterString
            }
            if OCWebActionManager.enableLog{
                NSLog("OCWebAction操作接口：%@，输出参数：%@", configure.url! , mergeParameterString)
            }
        }
        
        let url = try handlerURL(configure.url)
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy
            , timeoutInterval: 20)
        request.HTTPMethod = configure.httpMethod.rawValue
        if configure.headerFields != nil{
            for (key,value) in configure.headerFields!{
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    /**
     拼接参数
     :param: parameters 参数
     :returns: 结果
     */
    private func mergeParatemers(parameters:[String:String]) -> String{
        var result = ""
        var index = 0
        for ( key , value ) in parameters{
            if index == 0{
                result += "\(key)=\(value)"
            }else{
                result += "&\(key)=\(value)"
            }
            index++
        }
        return result
    }
    /**
     处理url字符串，并返回NSURL对象
     :param: url url字符串
     :returns: NSURL对象
     */
    private func handlerURL(url:String?) throws -> NSURL{
        guard url != nil else{
            throw NSError(domain: kOCWebErrorDomain, code: OCWebError.URLIsNil.rawValue , userInfo: nil)
        }
        let result = NSURL(string: url!)
        guard result != nil else{
            throw NSError(domain: kOCWebErrorDomain, code: OCWebError.URLIsNil.rawValue, userInfo: nil)
        }
        return result!
    }
}