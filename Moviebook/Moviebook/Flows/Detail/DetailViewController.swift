//
//  DetailViewController.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    var film: Film?
        
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.left.right.equalToSuperview().inset(16)
        }
        
        return nameLabel
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let releaseDateLabel = UILabel()
        releaseDateLabel.text = "Release date"
        releaseDateLabel.font = UIFont.systemFont(ofSize: 17)
        releaseDateLabel.textAlignment = .left
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(releaseDateLabel)
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).inset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        return releaseDateLabel
    }()
    
    lazy var overviewLabel: UILabel = {
        let overviewLabel = UILabel()
        overviewLabel.text = "Overview"
        overviewLabel.font = UIFont.systemFont(ofSize: 17)
        overviewLabel.textAlignment = .left
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(overviewLabel)
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLabel).inset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        return overviewLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        setModel()
    }
    
    func setModel() {
        guard let film = film else { return }
        
        nameLabel.text = film.title
        releaseDateLabel.text = setDataFormat(date: film.release_date)
        overviewLabel.text = film.overview
    }
    
    private func setDataFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        guard let backendData = dateFormatter.date(from: date) else { return "" }
        
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendData)
        return date
    }
}

