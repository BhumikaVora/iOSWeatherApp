//
//  WeatherAPIClientTests.swift
//  Created by Bhumika on 01/09/23.
//

@testable import iOSWeatherApp
import XCTest

final class WeatherAPIClientTests: XCTestCase {

    func testSearchLocationData() {
        WeatherAPIClient().searchLocation(searchText: "Munich") { locations, error in
            
            if let locations {
                let objLocation = locations.first
                XCTAssertTrue(objLocation?.name == "Munich")
                XCTAssertEqual(objLocation?.name, "Munich")
            }
            
            if let error {
                XCTFail("Error: \(error.localizedDescription)")
            }

        }
    }
    
    func testCurrentWeatherData() {
        WeatherAPIClient().getCurrentWeather(lat: 48.1739, lon: 11.2430) { currentWeather, error in
            
            XCTAssertNotNil(currentWeather)
            
            if let error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}
