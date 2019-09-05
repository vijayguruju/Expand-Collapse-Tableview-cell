//
//  ModelClass.swift
//  task_Vijay
//
//  Created by Dinesh Sunder on 30/31/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import Foundation


class AllMenuResponse {

    var name:[String]?
    var subCategory:[[[String:Any]]]?
    var dataArray :[[String:Any]]?
    init(name:[String],subCategory:[[[String:Any]]],dataArray:[[String:Any]]) {
        
        self.name = name
        self.subCategory = subCategory
        self.dataArray = dataArray
        
    }
    

}
