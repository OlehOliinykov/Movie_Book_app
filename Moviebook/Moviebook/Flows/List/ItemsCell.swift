//
//  ItemsCell.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import AVFoundation

protocol ItemsCellDelegate {
    func cellLongPress(cell: ItemsCell)
}

class ItemsCell: UICollectionViewCell {
    
    var cellDelegate: ItemsCellDelegate?
    let listVC = ListViewController()
    
     lazy var filmName: UILabel = {
        let labelCell = UILabel()
        labelCell.text = "Name film"
        labelCell.font = UIFont.systemFont(ofSize: 17)
        labelCell.textAlignment = .center
        labelCell.numberOfLines = 1
        labelCell.translatesAutoresizingMaskIntoConstraints = false
        
        return labelCell
    }()
    
     lazy var imageFilm: UIImageView = {
        let imageCell = UIImageView()
        imageCell.layer.cornerRadius = 16
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCell
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLongGestureRecognizerOnCollection()
      }
    
    func setup(item: Film) {
        if let urlString = item.poster_path {
            let url = "https://image.tmdb.org/t/p/w92/\(urlString)"
            
            guard let downloadURL = URL(string: url) else { return }
            let resource = ImageResource(downloadURL: downloadURL)
            let placeholder = UIImage(named: "placeholderPhoto")
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            
            self.imageFilm.kf.setImage(with: resource, placeholder: placeholder, options: [.processor(processor)], progressBlock: { (receivedSize, totalSize) in
                let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
                print("Downloading progress: \(percentage)%")
            }) { (result) in
                self.handle(result)
            }
        }
        
        filmName.text = item.title
    }
    
    func handle(_ result: Result<RetrieveImageResult, KingfisherError>) {
        switch result {
        case .success(let retreiveImageResult):
            _ = retreiveImageResult.image
            _ = retreiveImageResult.cacheType
            _ = retreiveImageResult.source
            _ = retreiveImageResult.originalSource
            
        case .failure(let error):
            print(error)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
     return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ItemsCell {
    func setupUI() {
        
        self.addSubview(self.imageFilm)
        self.imageFilm.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        self.addSubview(self.filmName)
        self.filmName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.right.left.equalToSuperview().inset(12)
        }
    }
}

extension ItemsCell: UIGestureRecognizerDelegate {
    
    func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        listVC.collectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            cellDelegate?.cellLongPress(cell: self)
            return
        }
    }
}
