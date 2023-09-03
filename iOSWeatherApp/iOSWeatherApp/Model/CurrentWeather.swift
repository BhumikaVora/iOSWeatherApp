//
//  CurrentWeather.swift
//  Created by Bhumika on 31/08/23.
//

import Foundation

struct CurrentWeather: Codable {
    let timezone, id: Int
    let name: String
    let coordinate: Coordinate
    let elements: [WeatherElement]
    let base: String
    let mainValue: CurrentWeatherMainValue
    let visibility: Int
    let wind: WeatherWind
    let clouds: WeatherClouds
    let date: Int
    let sys: CurrentWeatherSys
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case base, visibility, wind, clouds, sys, timezone, id, name
        case elements = "weather"
        case coordinate = "coord"
        case mainValue = "main"
        case date = "dt"
        case code = "cod"
    }
    
    static func emptyInit() -> CurrentWeather {
        return CurrentWeather(
            timezone: 0,
            id: 0,
            name: "",
            coordinate: Coordinate.emptyInit(),
            elements: [],
            base: "",
            mainValue: CurrentWeatherMainValue.emptyInit(),
            visibility: 0,
            wind: WeatherWind.emptyInit(),
            clouds: WeatherClouds.emptyInit(),
            date: 0,
            sys: CurrentWeatherSys.emptyInit(),
            code: 0
        )
    }
    
    func description() -> String {
        var result = "Today: "
        if let weatherElement = elements.first {
            result += "\(weatherElement.weatherDescription.capitalized) currently"
        }
        return result
    }

}
