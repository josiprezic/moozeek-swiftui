//
//  Int+TimeString.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 10/11/2022.
//

import Foundation

extension Int {
    var timeString: String {
        let minute = self / 60
        let second = self % 60
        return String(format: "%02i:%02i", minute, second)
    }
}

// TODO: JR To be moved
extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        var minutes = (time / 60) % 60
        minutes += Int(time / 3600) * 60  // to account for the hours as minutes
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
}
