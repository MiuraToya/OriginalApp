//
//  Task.swift
//  OriginalTask
//
//  Created by 三浦　登哉 on 2020/10/22.
//  Copyright © 2020 toya.miura. All rights reserved.
//

import RealmSwift

class Task: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var contents = ""
    @objc dynamic var date = Date()
    @objc dynamic var progresschoice = ""
    @objc dynamic var progress = ""
    
    override static func primaryKey() ->String?{
        return "id"
    }
}
