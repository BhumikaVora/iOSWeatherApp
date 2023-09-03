//
//  UserDefault+Helper.swift
//  Created by Bhumika on 01/09/23.
//

import UIKit

private enum Defaults: String {
   case temperatureUnit = "temperatureUnit"
}

final class UserDefaultHelper {

    static var temperatureUnit: String? {
        set{
            _set(value: newValue, key: .temperatureUnit)
        } get {
            return _get(valueForKay: .temperatureUnit) as? String ?? ""
        }
    }
    
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    private static func _get(valueForKay key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
