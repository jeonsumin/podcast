//
//  Podcast.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
