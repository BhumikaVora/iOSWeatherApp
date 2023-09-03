//
//  OpenweatherAPIClient.swift
//  Created by Bhumika on 29/08/23.
//

import Foundation

class WeatherAPIClient {
    
    typealias searchLocationCompletionHandler = ([Location]?, Error?) -> Void
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    
    private let BaseURL = "https://api.openweathermap.org/"
    private let apiKey = "fee527de9ad9d4c1b79bbe029bb00537"

    private enum SuffixURL: String {
        case searchLocation = "geo/1.0/direct"
        case currentWeather = "data/2.5/weather"
    }
    
    func getCurrentWeather(lat: Double, lon: Double, completionHandler completion: @escaping CurrentWeatherCompletionHandler)
    {
        guard let url = URL(string: "\(BaseURL)\(SuffixURL.currentWeather.rawValue)?APPID=\(apiKey)&lat=\(lat)&lon=\(lon)") else {
            print("Invalid URL!")
            return
        }
                
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            do{
                let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data!)
                completion(currentWeather, nil)
            }catch let jsonError {
                completion(nil, jsonError)
            }
        }.resume()
    }
    
    func searchLocation(searchText: String, completionHandler completion: @escaping searchLocationCompletionHandler)
    {
        guard let url = URL(string: "\(BaseURL)\(SuffixURL.searchLocation.rawValue)?APPID=\(apiKey)&q=\(searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))") else {
            print("Invalid URL!")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([], error)
                return
            }
            
            do{
                let locations = try JSONDecoder().decode([Location].self, from: data!)
                completion(locations, nil)
            }catch let jsonError {
                completion([], jsonError)
            }
        }.resume()
    }

}
