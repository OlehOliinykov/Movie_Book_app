//
//  FavDetailViewController.swift
//  Moviebook
//
//  Created by Влад Овсюк on 14.07.2022.
//

import Foundation
import UIKit
import SnapKit

class FavDetailViewController: UIViewController {
    
    var film: Film?
    var genre: Genres?
    
    lazy var nameLabel: UILabel = {
        let nameFavFilm = UILabel()
        nameFavFilm.text = "Name"
        nameFavFilm.font = UIFont.systemFont(ofSize: 17)
        nameFavFilm.textAlignment = .center
        nameFavFilm.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameFavFilm)
        nameFavFilm.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.right.left.equalToSuperview().inset(16)
        }
        
        return nameFavFilm
    }()
    
    lazy var genreLabel: UILabel = {
        let genreFavFilm = UILabel()
        genreFavFilm.text = "Name"
        genreFavFilm.font = UIFont.systemFont(ofSize: 17)
        genreFavFilm.textAlignment = .center
        genreFavFilm.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(genreFavFilm)
        genreFavFilm.snp.makeConstraints { make in
            make.top.equalTo(nameLabel).inset(20)
            make.right.left.equalToSuperview().inset(16)
        }
        
        return genreFavFilm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Detail"
        setModel()
    }
    
    func setModel() {
        guard let film = film else { return }
        guard let genre = genre else { return }

        nameLabel.text = film.title
        genreLabel.text = genre.name
    }
        
}
