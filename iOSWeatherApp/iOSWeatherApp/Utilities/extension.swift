//
//  extension.swift
//  Created by Bhumika on 31/08/23.
//

import Foundation
import UIKit

extension Int {
    func dateFromMilliseconds() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}

extension Date {
    func dayWord() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func dayMonthly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func hour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }

    func hourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        return dateFormatter.string(from: self)
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIAlertController {
    static func actionSheetWithItems<A : Equatable>(title: String, items : [(title : String, value : A)], currentSelection : A? = nil, action : @escaping (A) -> Void) -> UIAlertController
    {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for (var title, value) in items {
            if let selection = currentSelection, value == selection {
                // Note that checkmark and space have a neutral text flow direction so this is correct for RTL
                title = "✔︎ " + title
            }
            controller.addAction(
                UIAlertAction(title: title, style: .default) {_ in
                    action(value)
                }
            )
        }

        return controller
    }
}
