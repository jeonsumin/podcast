//
//  MainTabBarController.swift
//  Podcast
//
//  Created by Terry on 2023/04/16.
//

import UIKit

class MainTabBarController:UITabBarController{
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 컨트롤러의 타이틀 속성값을 큰글씨로 변경
        UINavigationBar.appearance().prefersLargeTitles = true
        
        // 탭바의 틴트 컬러를 시스템 보라색으로 선언
        tabBar.tintColor = .systemPurple
        
        
        setupViewControllers()
        
        setupPlayerDetailsView()
        
        perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
    }
    
    
    //MARK: Setup Function
    
    @objc func minimizedPlayerDetails(){
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func maximizePlayerDetails(){
        
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0 
        minimizedTopAnchorConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func setupPlayerDetailsView(){
        print("Setting up PlayerDetailsView")
        let playerDetailsView = PlayerDetailsView.initFromNib()
        
//        view.addSubview(playerDetailsView)
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
    
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height)
        
//        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor,constant: -64)
        minimizedTopAnchorConstraint.isActive = true
        
//        playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor,constant: -64).isActive = true
//        playerDetailsView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        
    }
    
    func setupViewControllers(){
        //탭바 아이템 주입
        viewControllers = [
            generateNavigationController(for: SearchController(), title: "Search", image: UIImage(named: "search")!),
            generateNavigationController(for: ViewController(), title: "Favorites", image: UIImage(named: "favorites")!),
            generateNavigationController(for: ViewController(), title: "Downloads", image: UIImage(named: "downloads")!)
        ]
    }
    
    //MARK: Function
    ///공통소스 메소드화 하여 선언
    ///네비게이션 컨트롤러 공통 속성 및 navigationViewController 주입
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage ) -> UIViewController {

        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
        
    }
}
