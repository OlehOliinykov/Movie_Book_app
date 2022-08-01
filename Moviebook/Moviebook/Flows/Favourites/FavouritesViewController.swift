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
    
    var networkDataFetcher = NetworkDataFetcher()
    var favFilm = [Film?]()
    var favGenre = [Genres?]()
    var filterArray = [Genres?]()
    var configurationImage: ImageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "⭐️ Favourite"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        setupUICollectionView()
        setupLongGestureRecognizer()
        setupDelegate()
        requestImage()
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
    
    func setupUICollectionView() {
        self.view.addSubview(self.favCollectionView)
        self.favCollectionView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
        
    private func requestImage() {
        networkDataFetcher.fetchImage { [weak self] (requestResult) in
            guard let requestResult = requestResult else { return }
            DispatchQueue.main.async {
                self?.configurationImage = requestResult
                self?.favCollectionView.reloadData()
            }
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
        cell.setup(item: film, configurationImage: configurationImage)
        cell.backgroundColor = UIColor(red: 234/255, green: 213/255, blue: 230/255, alpha: 1)
        cell.layer.cornerRadius = 16
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favDetail = UIStoryboard(name: "FavDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "FavDetail") as! FavDetailViewController
        let navFavourite = UINavigationController(rootViewController: favDetail)
        let favouriteFilm = favFilm[indexPath.item]
        let favouriteGenre = favGenre[indexPath.item]
        favDetail.film = favouriteFilm
        favDetail.genre = favouriteGenre
        navFavourite.modalPresentationStyle = .pageSheet
        if let sheet = navFavourite.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(navFavourite, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (favCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 314)
    }
    
}

extension FavouritesViewController: UIGestureRecognizerDelegate {
    private func setupLongGestureRecognizer() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        favCollectionView.addGestureRecognizer(longPressedGesture)
    }

    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }

        let touchPoint = gestureRecognizer.location(in: favCollectionView)

        if let indexPath = favCollectionView.indexPathForItem(at: touchPoint) {
            favFilm.remove(at: indexPath.item)
            favGenre.remove(at: indexPath.item)
            favCollectionView.reloadData()
        }
    }
}
