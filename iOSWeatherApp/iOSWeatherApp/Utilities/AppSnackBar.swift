//
//  AppSnackBar.swift
//  Created by Bhumika on 01/09/23.
//

import SnackBar

class AppSnackBar: SnackBar {
    
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .black
        style.textColor = .white
        style.actionTextColor = .white
        return style
    }
}
