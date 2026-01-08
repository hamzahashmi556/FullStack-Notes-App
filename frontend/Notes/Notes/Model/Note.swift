//
//  Note.swift
//  Notes
//
//  Created by Hamza Hashmi on 08/01/2026.
//

import Foundation

struct Note: Codable, Identifiable {
    var id: String
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case note
    }
}
