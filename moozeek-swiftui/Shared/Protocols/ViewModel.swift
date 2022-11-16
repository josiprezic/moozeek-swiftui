//
//  ViewModel.swift
//  moozeek-swiftui
//
//  Created by Josip Rezic on 16/11/2022.
//

import Resolver

class ViewModel {
    static var resolved: Self {
        Resolver.resolve(Self.self)
    }
    
    init() {
        setupObservables()
    }
    
    func setupObservables() {}
}
