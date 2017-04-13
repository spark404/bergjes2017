//
//  Extensions.swift
//  Bergjes2017
//
//  Created by Hugo Trippaers on 13/04/2017.
//  Copyright © 2017 Hugo Trippaers. All rights reserved.
//

import Foundation

extension URL {
    public var queryItems: [String: String] {
        var params = [String: String]()
        return URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce([:], { (_, item) -> [String: String] in
                params[item.name] = item.value
                return params
            }) ?? [:]
    }
}
