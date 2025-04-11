//
//  Memory.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import Foundation

struct Memory: Identifiable, Codable, Equatable{
    let id: UUID
    var title: String
    var date: Date
    var description: String
    var imageName: String
    var audioFileName: String?
}


