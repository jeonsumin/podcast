//
//  SearchController.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import UIKit

import UIKit
import Alamofire

class SearchController: UITableViewController {
    
    //MARK: - Properties 
    //팟캐스트 데이터 변수 초기화
    var podcasts = [Podcast]()
    
    //cell Identifier를 선언합니다.
    let cellId = "Cell"
    
    // UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    var timer: Timer?
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "뉴스")
    }
    
    
    //MARK: - helper
    func setupTableView(){
        tableView.tableFooterView = UIView()
        
        // 1. register
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    func setupSearchBar(){
        
        //다른 뷰를 표시할때 해당 뷰가 표시되는지 여부 판단
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.delegate = self
        
    }
    
    
}

//MARK: - UITableView delegate and dataSource
extension SearchController{
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodController = EpisodeController()
        let podcast = self.podcasts[indexPath.row]
        episodController.podcast = podcast
        navigationController?.pushViewController(episodController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "결과가 없습니다. "
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PodcastCell else { return UITableViewCell() }

        let podcast = self.podcasts[indexPath.row]
    
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

//MARK: - SearchBar Delegate
extension SearchController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            APIService.shared.fetchPodcast(searchText: searchText) { snapshot in
                self.podcasts = snapshot
                self.tableView.reloadData()
            }
        })   
    }
}
