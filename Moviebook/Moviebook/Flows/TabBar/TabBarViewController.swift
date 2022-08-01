//
//  TabBar.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation
import UIKit
import SnapKit

class RootViewController: UIViewController {
    
    let tabBarVC = TabBarViewController()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC()
    }
    
    func addChildVC() {
        
        addChild(tabBarVC)
        view.addSubview(tabBarVC.view)
        tabBarVC.view.translatesAutoresizingMaskIntoConstraints = false
        tabBarVC.view.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

protocol passCellDelegate: AnyObject {
    func passCell(_ filmCollectionViewCell: ItemsCell, handleLongPressFor indexFavourite: Film)
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate, passCellDelegate {
    
    var favouritesViewController = UIStoryboard(name: "FavouritesViewController", bundle: nil).instantiateViewController(withIdentifier: "Favourites") as! FavouritesViewController
    let listViewController = UIStoryboard(name: "ListViewController", bundle: nil).instantiateViewController(withIdentifier: "List") as! ListViewController
    
    let networkDataFetcher = NetworkDataFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewController.passDelegate = self
        delegate = self
        setupTabBar()
    }
    
    func passCell(_ filmCollectionViewCell: ItemsCell, handleLongPressFor indexFavourite: Film) {
        NetworkService.shared.idValue = indexFavourite.id
        requestGenre()
        favouritesViewController.favFilm.append(indexFavourite)
        favouritesViewController.favCollectionView.reloadData()
        
    }
    
    private func requestGenre() {
        networkDataFetcher.fetchGenre { [weak self] (requestResult) in
            guard let requestResult = requestResult else { return }
            DispatchQueue.main.async {
                self?.favouritesViewController.filterArray = requestResult.genres
                self?.favouritesViewController.favGenre.append(self?.favouritesViewController.filterArray[0])
            }
        }
    }
    
    func setupTabBar() {
        let navFavourites = generateNavController(vc: favouritesViewController, title: "Favourite", image: UIImage(imageLiteralResourceName: "Heart"))
        let navList = generateNavController(vc: listViewController, title: "List", image: UIImage(imageLiteralResourceName: "Film"))
        
        viewControllers = [navList, navFavourites]
    }
        
    fileprivate func generateNavController(vc: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
