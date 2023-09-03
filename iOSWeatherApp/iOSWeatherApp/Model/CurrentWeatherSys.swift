//
//  CurrentWeatherSys.swift
//  Created by Bhumika on 31/08/23.
//

import Foundation

struct CurrentWeatherSys: Codable {
    let id: Int?
    let type: Int?
    let country: String
    let sunrise, sunset: Int
    
    static func emptyInit() -> CurrentWeatherSys {
        return CurrentWeatherSys(
            id: 0,
            type: 0,
            country: "",
            sunrise: 0,
            sunset: 0
        )
    }
}
