//
//  OCWebActionManager.swift
//  OCWebAction
//
//  Created by oceannw on 16/2/15.
//  Copyright © 2016年 oceannw. All rights reserved.
//

import Foundation

class OCWebActionManager {
    
    static let shareManager = OCWebActionManager()
    
    /// enable logging(use NSLog),default is true
    static var enableLog = true
    
    private init(){}
    
    func getSynchronousAction() -> OCWebActionProtocol{
        return OCSynchronousAction()
    }
    
    func getSynchronousReconnectAction() -> OCWebActionProtocol{
        return OCSynchronousReconnectAction()
    }
    
    func getAsynchronousAction() -> OCWebActionProtocol{
        return OCAsynchronousAction()
    }
}