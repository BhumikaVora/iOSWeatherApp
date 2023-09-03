//
//  WeatherClouds.swift
//  Created by Bhumika on 31/08/23.
//

import Foundation

struct WeatherClouds: Codable {
    let all: Int

    static func emptyInit() -> WeatherClouds {
        return WeatherClouds(all: 0)
    }
}
