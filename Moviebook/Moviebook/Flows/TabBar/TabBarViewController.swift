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
    func passCell(_ filmCollectionViewCell: ItemsCell, handleLongPressFor indexFavourite: Film) {
        favouritesViewController.favFilm.append(indexFavourite)
        favouritesViewController.favCollectionView.reloadData()
    }
    
    var favouritesViewController = UIStoryboard(name: "FavouritesViewController", bundle: nil).instantiateViewController(withIdentifier: "Favourites") as! FavouritesViewController
    let listViewController = UIStoryboard(name: "ListViewController", bundle: nil).instantiateViewController(withIdentifier: "List") as! ListViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewController.passDelegate = self
        delegate = self
        setupTabBar()
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
