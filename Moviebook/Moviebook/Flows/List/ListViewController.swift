//
//  ListViewController.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation
import SnapKit
import UIKit
import SwiftUI

class ListViewController: UIViewController {
    
    weak var passDelegate: passCellDelegate?
    var indexFavourite: Film?
    var films = [Film]()
    let api = "f048e427d91bfded37eee1e7a69876fd"
    
    var networkDataFetcher = NetworkDataFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        setupCollectionViewUI()
        setupDelegate()
        setupRecognizer()
//        fetchFilm(api: api)
        requestFilm()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "🎬 Films"
    }

    lazy var listCollectionView: UICollectionView = { [weak self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 20
        flow.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
        collectionView.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        return collectionView
    }()
    
    func setupDelegate() {
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
    }
    
    func setupCollectionViewUI() {
        self.view.addSubview(self.listCollectionView)
        self.listCollectionView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalTo(self.view)
        }
    }
    
    private func requestFilm() {
        networkDataFetcher.fetchFilm { [weak self] (requestResult) in
            guard let requestResult = requestResult else { return }

            self?.films = requestResult.results
            self?.listCollectionView.reloadData()
            print(requestResult)
        }
        
    }
    
//    private func fetchFilm(api: String) {
//        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(api)"
//
//        NetworkDataFetch.shared.fetchFilm(urlString: urlString) { [weak self] filmModel, error in
//            if error == nil {
//                guard let filmModel = filmModel else { return }
//                if filmModel.results != [] {
//                    self?.films = filmModel.results
//                    self?.listCollectionView.reloadData()
//                } else {
//                    print("Array is empty")
//                }
//            } else {
//                print(error!.localizedDescription)
//            }
//        }
//    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        let film = films[indexPath.item]
        cell.setup(item: film)
        cell.backgroundColor = UIColor(red: 234/255, green: 213/255, blue: 230/255, alpha: 1)
        cell.layer.cornerRadius = 16
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let navDetail = UINavigationController(rootViewController: detailScreen)
        let film = films[indexPath.item]
        detailScreen.film = film
        detailScreen.title = "Detail"
        self.present(navDetail, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowLayout?.minimumInteritemSpacing ?? 0.0) + (flowLayout?.sectionInset.left ?? 0.0) + (flowLayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}

extension ListViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            guard let indexFavourite = indexFavourite else { return }
            passDelegate?.passCell(ItemsCell(), handleLongPressFor: indexFavourite)
        }
        let touchPoint = gestureRecognizer.location(in: listCollectionView)

        if let indexPath = listCollectionView.indexPathForItem(at: touchPoint) {
            indexFavourite = films[indexPath.item]
        }
    }
    
    func setupRecognizer() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        
        listCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
}
