//
//  EpisodeController.swift
//  Podcasts
//
//  Created by Terry on 2023/04/16.
//

import UIKit
import FeedKit

class EpisodeController:UITableViewController {
    
    //MARK: - Properties 
    var podcast: Podcast? {
        didSet{
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate let cellId = "cellId"
    
    fileprivate func fetchEpisodes(){
        guard let feedUrl = podcast?.feedUrl else { return }

        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var episodes = [Episode]()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
    }
    
    //MARK: - Helper 
    func setupTableView(){
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
}

//MARK: - TableView Delegate And DataSource
extension EpisodeController {
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        mainTabBarController.maximizePlayerDetails(episode: episode)
        
//        let episode = self.episodes[indexPath.row]
//
//        print("Trying to play Episode", episode.title)
//
//        let window = UIApplication.shared.keyWindow
//
//        let playerDetailView = PlayerDetailsView.initFromNib()
//
//        // 플레이어 디테일 뷰에 선택한 셀의 에피소드  주입
//        playerDetailView.episode = episode
//
//        //플레이어 디에틸 뷰의 프레임을 현재 뷰 프레임에 추가
//        playerDetailView.frame = self.view.frame
//        window?.addSubview(playerDetailView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
