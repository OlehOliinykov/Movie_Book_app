//
//  FavouritesViewController.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation
import SnapKit
import UIKit

class FavouritesViewController: UIViewController {
    
    var favFilm: [Film] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        self.navigationItem.title = "⭐️ Favourite"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        
        setupDelegate()
        setupCollectionViewUI()
    }
    
    lazy var favCollectionView: UICollectionView = { [weak self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 20
        flow.minimumInteritemSpacing = 20
        let favCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        favCollectionView.isScrollEnabled = true
        favCollectionView.isPagingEnabled = false
        favCollectionView.showsVerticalScrollIndicator = false
        favCollectionView.showsHorizontalScrollIndicator  = false
        favCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favCollectionView.register(FavouritesCell.self, forCellWithReuseIdentifier: "FavouritesCell")
        favCollectionView.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        return favCollectionView
    }()
    
    func setupDelegate() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
    }
    
    func setupCollectionViewUI() {
        self.view.addSubview(self.favCollectionView)
        self.favCollectionView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
    
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favFilm.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouritesCell", for: indexPath) as! FavouritesCell
        let film = favFilm[indexPath.item]
        cell.setup(item: film)
        cell.backgroundColor = UIColor(red: 234/255, green: 213/255, blue: 230/255, alpha: 1)
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
}