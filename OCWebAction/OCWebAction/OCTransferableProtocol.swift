//
//  OCTransferableProtocol.swift
//
//  Created by oceannw on 15/10/29.
//  Copyright © 2015年 oceannw. All rights reserved.
//

import Foundation
/**
 *  网络接口返回数据所转换的实体类
 */
protocol OCTransferableProtocol{}

/// 网络接口返回数据所转换的实体数组类
protocol OCTransferableListProtocol: OCTransferableProtocol {
    var list:[OCTransferableProtocol]{set get}
}

///默认的转换实体类
class OCTransferableNilObject:OCTransferableProtocol{}

///默认的转换实体数组类
class OCTransferableListNilObject:OCTransferableListProtocol {
    var list:[OCTransferableProtocol] = [OCTransferableNilObject]()
}