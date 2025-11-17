//
//  Item.swift
//  ChatOllama 2
//
//  Created by Sicheng Jiang on 2024-06-15.
//

import Foundation
import SwiftData

@Model
final class Dialogue {
    @Attribute(.unique) var id: UUID = UUID()
    var query: String
    var response: String
    
    init(query: String, response: String) {
        self.query = query
        self.response = response
    }
}
