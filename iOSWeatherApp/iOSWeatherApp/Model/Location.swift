//
//  Location.swift
//  Created by Bhumika on 31/08/23.
//
import Foundation

struct Location: Codable, Hashable {
    var name: String
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?

    enum CodingKeys: String, CodingKey {
        case name, country
        case state
        case lat, lon
    }
    
    static func emptyInit() -> Location {
        return Location(
            name: "",
            lat: 0.0,
            lon: 0.0,
            country: "",
            state: "")
    }
}
