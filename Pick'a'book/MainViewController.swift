//
//  ViewController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let genrePresenter = SearchPresenter()
        let genresVC = UINavigationController(rootViewController: SearchController(output: genrePresenter))
        genresVC.tabBarItem.image = UIImage(named: "SearchViewIcon")
        genresVC.title = ""
        
        let myProfilePresenter = ProfilePresenter()
        let myProfileVC = UINavigationController(rootViewController: ProfileController(output: myProfilePresenter))
        myProfileVC.tabBarItem.image = UIImage(named: "ProfileViewIcon")
        myProfileVC.title = ""

        let libraryPresenter = LibraryPresenter()
        let libraryVC = UINavigationController(rootViewController: LibraryController(presenter: libraryPresenter))
        libraryVC.tabBarItem.image = UIImage(named: "AddViewIcon")
        libraryVC.title = ""
        
        self.setViewControllers([genresVC, libraryVC, myProfileVC], animated: false)
        self.modalPresentationStyle = .fullScreen
        self.tabBar.backgroundColor = .white
                                
        self.tabBar.tintColor = .black
    }
}

