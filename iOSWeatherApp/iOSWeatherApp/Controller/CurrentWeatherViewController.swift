//
//  ViewController.swift
//  Created by Bhumika on 31/08/23.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    private enum TemperatureUnit: String {
        case Celsius
        case Fahrenheit
    }

    @IBOutlet var lblLocationName: UILabel!
    @IBOutlet var lbltemp: UILabel!
    @IBOutlet var lblWeather: UILabel!
    @IBOutlet var lblWeatherDescription: UILabel!
    @IBOutlet var lblSunrise: UILabel!
    @IBOutlet var lblSunset: UILabel!
    @IBOutlet var lblPressure: UILabel!
    @IBOutlet var lblHumidity: UILabel!
    @IBOutlet var lblVisibility: UILabel!
    @IBOutlet var lblFeelsLike: UILabel!
    @IBOutlet var lblHighTemp: UILabel!
    @IBOutlet var lblLowTemp: UILabel!

    var selectedLocation: Location?
    var currentWeather: CurrentWeather?
    
    var currentCity = String()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchLocationVC = segue.destination as? SearchLocationController {
            searchLocationVC.callback = { locationObj in

                self.selectedLocation = locationObj
                if Reachability.isConnectedToNetwork() {
                    self.getCurrentWeather(lat: self.selectedLocation?.lat ?? 0.0, lon: self.selectedLocation?.lon ?? 0.0)
                }
                else {
                    self.showNoInternetToast()
                }
            }
        }
    }

    func getCurrentWeather(lat: Double, lon: Double) {
        WeatherAPIClient().getCurrentWeather(lat: lat, lon: lon) { currentWeather, error in
            
            guard let currentWeather = currentWeather else {
                return }
            
            self.currentWeather = currentWeather
            Async.main({ [weak self] in
                guard let strongSelf = self else { return }

                strongSelf.configureData(currentWeather: strongSelf.currentWeather!)
            })
        }
    }
    
    func getCurrentCity(currentLocation: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
            
            if error != nil {
                return
            }
            else if let city = placemarks?.first?.locality {
                self.currentCity = city
            }
        }
    }

    func configureData(currentWeather: CurrentWeather) {
        self.lblLocationName.text = self.selectedLocation?.name ?? self.currentCity
        self.lbltemp.text = convertTempUnitValue(temp: currentWeather.mainValue.temp)
        self.lblWeather.text =  currentWeather.elements.first?.main
        self.lblWeatherDescription.text = currentWeather.description()
        self.lblSunrise.text = currentWeather.sys.sunrise.dateFromMilliseconds().hourMinute()
        self.lblSunset.text = currentWeather.sys.sunset.dateFromMilliseconds().hourMinute()
        self.lblPressure.text = "\(currentWeather.mainValue.pressure) hPa"
        self.lblHumidity.text = "\(currentWeather.mainValue.humidity)%"
        self.lblVisibility.text = "\(Float(currentWeather.visibility/1000)) Km"
        self.lblFeelsLike.text = convertTempUnitValue(temp: currentWeather.mainValue.feelsLike)
        self.lblHighTemp.text = convertTempUnitValue(temp: currentWeather.mainValue.tempMax)
        self.lblLowTemp.text = convertTempUnitValue(temp: currentWeather.mainValue.tempMin)
    }
    
    func convertTempUnitValue(temp: Double) -> String {
        let tempUnit = UserDefaultHelper.temperatureUnit
        if tempUnit == TemperatureUnit.Fahrenheit.rawValue {
            return "\(Int((temp - 273.15) * 9 / 5 + 32))°"
        }
        return "\(Int(temp - 273.15))°"
    }

    @IBAction func btnSettingClicked(button: UIBarButtonItem) {
        setTemperatureUnit()
    }
    
    func setTemperatureUnit() {
        let action = UIAlertController.actionSheetWithItems(
            title: AppConstant.TemperatureUnitTitle,
            items: [
                ("Celsius", TemperatureUnit.Celsius.rawValue),
                ("Fahrenheit", TemperatureUnit.Fahrenheit.rawValue)
            ],
            currentSelection: UserDefaultHelper.temperatureUnit,
            action: { (value)  in
                UserDefaultHelper.temperatureUnit = value

                guard let weather = self.currentWeather else { return }
                self.configureData(currentWeather: weather)
            })
        action.addAction(
            UIAlertAction.init(
                title: AppConstant.Cancel,
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        action.view.tintColor = .gray
        //Present the controller
        self.present(action, animated: true, completion: nil)
    }
    
    func showNoInternetToast(){
        AppSnackBar.make(
            in: self.view,
            message: AppConstant.InternetConnectionMessage, duration: .lengthLong)
        .setAction(with: AppConstant.Retry, action: {
        }).show()
    }
    
}

extension CurrentWeatherViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppSnackBar.make(in: self.view, message: error.localizedDescription, duration: .lengthShort).show()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationSafe = locations.last else { return }

        locationManager.stopUpdatingLocation()
        let latitude = locationSafe.coordinate.latitude
        let longitude = locationSafe.coordinate.longitude
            
        if Reachability.isConnectedToNetwork() {
            self.getCurrentCity(currentLocation: locationSafe)
            self.getCurrentWeather(lat: latitude, lon: longitude)
        }
        else {
            self.showNoInternetToast()
        }
    }

}
