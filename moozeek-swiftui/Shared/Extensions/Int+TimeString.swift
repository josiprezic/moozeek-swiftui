//
//  Int+TimeString.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import Foundation

extension Int {
    var asTimeString: String {
        let minute = self / 60
        let second = self % 60
        return String(format: "%02i:%02i", minute, second)
    }
}
