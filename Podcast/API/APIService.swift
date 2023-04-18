//
//  APIService.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    //singleton
    static let shared = APIService()
    
    let baseiTunesSerachURL = "https://itunes.apple.com/search"
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping([Episode]) -> () ){
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
     
        
        DispatchQueue.global(qos: .background).async {
            print("Before parser")
            let parser = FeedParser(URL: url)
            print("after parser")
            parser.parseAsync(result: { result in
                switch result {
                case .success(let feed):
                    switch feed {
                    case let .rss(feed):
                        completionHandler(feed.toEpisodes())
                        break
                    default :
                        print("Found a feed ... ")
                    }
                    
                case .failure(let error):
                    print("Failed to parse feed : ",error)
                }
            })
        }
        
    }
    
    func fetchPodcast(searchText: String, completionHandler: @escaping ([Podcast]) -> ()){
    
        //iTunes API
    
        let parameters = [
            "term": searchText,
            "media": "podcast",
            "country": "KR"
        ]
        
        AF.request(baseiTunesSerachURL, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: nil ).responseData { (res) in
            if let err = res.error {
                print("err", err)
                return
            }
            guard let data = res.data else { return }
        
            do{
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                completionHandler(searchResult.results)
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()
                
            }catch let decodeErr {
                print("Failed to Decode: ", decodeErr)
            }
        }
    }
    
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
}
