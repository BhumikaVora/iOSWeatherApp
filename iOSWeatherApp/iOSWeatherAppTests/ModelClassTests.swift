//
//  ModelClassTests.swift
//  Created by Bhumika on 01/09/23.
//

@testable import iOSWeatherApp
import XCTest

final class ModelClassTests: XCTestCase {

    func testLocationModel() {
        let instance = Location(name: "Munich")
        XCTAssertNotNil(instance)
    }
    
    func testCurrentWeatherModel() {
        let instance = CurrentWeather(
            timezone: 5000,
            id: 11,
            name: "Munich",
            coordinate: Coordinate(lon: 48.1351, lat: 11.5820),
            elements: [WeatherElement(id: 123,
                                      main: "Rain",
                                      weatherDescription: "overcast clouds",
                                      icon: "o4d")],
            base: "stations",
            mainValue: CurrentWeatherMainValue(temp: 18.06,
                                               feelsLike: 20.08,
                                               tempMin: 12.09,
                                               tempMax: 23.09,
                                               pressure: 1000,
                                               humidity: 61),
            visibility: 1000,
            wind: WeatherWind(speed: 1.34, deg: 233),
            clouds: WeatherClouds(all: 95),
            date: 1693496405,
            sys: CurrentWeatherSys(id: 232,
                                   type: 2,
                                   country: "Germany",
                                   sunrise: 1693456178,
                                   sunset: 1693504749),
            code: 0)
        XCTAssertNotNil(instance)
    }
    
    
}
