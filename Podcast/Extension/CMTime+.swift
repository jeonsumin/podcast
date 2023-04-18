//
//  CMTime+.swift
//  Podcast
//
//  Created by Terry on 2023/04/18.
//

import AVKit

extension CMTime {
    func toDisplayString() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeformatString = String(format: "%02d:%02d",minutes, seconds)
        
        return timeformatString
    }
}
