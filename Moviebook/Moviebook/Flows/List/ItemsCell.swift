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

class ItemsCell: UICollectionViewCell {
        
    lazy var filmName: UILabel = {
        let labelCell = UILabel()
        labelCell.text = "Name film"
        labelCell.font = UIFont.systemFont(ofSize: 17)
        labelCell.textAlignment = .center
        labelCell.numberOfLines = 1
        labelCell.backgroundColor = UIColor(red: 104/255, green: 95/255, blue: 116/255, alpha: 0.05)
        
        labelCell.translatesAutoresizingMaskIntoConstraints = false
        
        return labelCell
    }()
    
    lazy var imageFilm: UIImageView = {
        let imageCell = UIImageView()
        imageCell.translatesAutoresizingMaskIntoConstraints = false
        
        return imageCell
    }()
        
    func setup(item: Film, configurationImage: ImageModel?) {
        guard configurationImage != nil else { return }
        if let urlString = item.poster_path,
            let configuration = configurationImage?.images.secure_base_url,
            let size = configurationImage?.images.poster_sizes[1] {
            
            let url = "\(configuration)\(size)\(urlString)"
            
            guard let downloadURL = URL(string: url) else { return }
            let resource = ImageResource(downloadURL: downloadURL)
            let placeholder = UIImage(named: "placeholderPhoto")
            let processor = RoundCornerImageProcessor(cornerRadius: 8)
            
            self.imageFilm.kf.setImage(with: resource,
                                       placeholder: placeholder,
                                       options: [.processor(processor)],
                                       progressBlock: { (receivedSize, totalSize) in
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
        }
        
        self.addSubview(self.filmName)
        self.filmName.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.right.left.equalToSuperview().inset(32)
        }
    }
}
