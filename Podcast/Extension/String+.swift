//
//  String.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import Foundation

extension String{
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self :
        self.replacingOccurrences(of: "http", with: "https")
    }
}
