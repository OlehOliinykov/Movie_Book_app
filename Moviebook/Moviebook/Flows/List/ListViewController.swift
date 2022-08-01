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
    
    var networkDataFetcher = NetworkDataFetcher()
    weak var passDelegate: passCellDelegate?
    var indexFavourite: Film?
    var films = [Film]()
    var configurationImage: ImageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestFilm()
        requestImage()
        setupDelegate()
        setupRecognizer()
        setupCollectionViewUI()
        self.navigationItem.title = "🎬 Films"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
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
            DispatchQueue.main.async {
                self?.films = requestResult.results
                self?.listCollectionView.reloadData()
            }
        }
    }
    
    private func requestImage() {
        networkDataFetcher.fetchImage { [weak self] (requestResult) in
            guard let requestResult = requestResult else { return }
            DispatchQueue.main.async {
                self?.configurationImage = requestResult
                self?.listCollectionView.reloadData()
            }
        }
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        let film = films[indexPath.item]
        cell.setup(item: film, configurationImage: configurationImage)
        cell.backgroundColor = UIColor(red: 234/255, green: 213/255, blue: 230/255, alpha: 1)
        cell.layer.cornerRadius = 16
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailScreen = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let navDetail = UINavigationController(rootViewController: detailScreen)
        let film = films[indexPath.item]
        detailScreen.film = film
        navDetail.modalPresentationStyle = .pageSheet
        if let sheet = navDetail.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(navDetail, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (listCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: 314)
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
            guard let indexFavourite = indexFavourite else { return }
            let alert = UIAlertController(title: "Added", message: "Film \(indexFavourite.title ?? "") added to favourite", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
