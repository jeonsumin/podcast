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
    
    //MARK: - Properties
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
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            print("episode started playing ")
            self.enlargeEpisodeImageView()
        }
    }
    
    //MARK: -IBOutlet
    //재생 정지 버튼
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(hanldePlayPause), for: .touchUpInside)
        }
    }
    
    //에피소드 소유자?
    @IBOutlet weak var authorLabel: UILabel!
    
    //에피소드 타이틀
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    //에피소드 이미지 뷰
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            episodeImageView.transform = shrunkenTransfrom
        }
    }
    
    // 팝업 닫는 버튼
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
            enlargeEpisodeImageView()
        }else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    fileprivate let shrunkenTransfrom = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargeEpisodeImageView(){
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       animations: {
                            self.episodeImageView.transform = .identity
                        })
    }
    
    fileprivate func shrinkEpisodeImageView(){
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       animations: {
                            self.episodeImageView.transform = self.shrunkenTransfrom
                        })
    }
}
