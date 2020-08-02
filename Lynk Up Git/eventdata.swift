//
//  eventdata.swift
//  Meep
//
//  Created by Thomas D'Alessandro on 7/4/20.
//  Copyright © 2020 Katia K Brinsmade. All rights reserved.
//

import SwiftUI

struct eventdata: Identifiable, Decodable {

    var id: Int
    let user_profile: Int
    let poi: String?
    let address: String
    let start_time: String
    let end_time: String
    
}

