//
//  ReuseIdentyfying.swift
//  RememberTest
//
//  Created by 장근형 on 2/6/25.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
