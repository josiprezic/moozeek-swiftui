//
//  View+Resolved.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Resolver
import SwiftUI

extension View {
    static var resolved: Self {
        Resolver.resolve(Self.self)
    }
}
