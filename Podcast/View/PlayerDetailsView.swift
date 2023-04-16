//
//  PlayerDetailsView.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import UIKit
import SDWebImage
import AVKit

class PlayerDetailsView:UIView{
    var episode: Episode! {
        didSet{
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            guard let url = URL(string: episode.imageUrl ?? "" ) else {return }
         
            playerEpisode()
            episodeImageView.sd_setImage(with: url)
        }
    }
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(hanldePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    func playerEpisode(){
        print("stream url " , episode.streamUrl)
        
        guard let url = URL(string: episode.streamUrl) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    @objc
    func hanldePlayPause(){
        print("tapped play and pause")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        
        
        
    }
    
}
