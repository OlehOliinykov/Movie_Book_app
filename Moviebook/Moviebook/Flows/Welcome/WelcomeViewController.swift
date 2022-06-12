//
//  ViewController.swift
//  Moviebook
//
//  Created by Влад Овсюк on 12.06.2022.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor(red: 243/255, green: 224/255, blue: 236/255, alpha: 1)
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "👋 Welcome!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(150)
        }
        
        let welcomeButton = UIButton()
        welcomeButton.backgroundColor = UIColor(red: 104/255, green: 95/255, blue: 116/255, alpha: 1)
        welcomeButton.layer.cornerRadius = 16
        welcomeButton.setTitleColor(.white, for: .normal)
        welcomeButton.setTitle("🖐Hello!", for: .normal)
        view.addSubview(welcomeButton)
        welcomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(64)
        }
        welcomeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        let storyboard = UIStoryboard(name: "TabBarViewController", bundle: nil)
        let newVc: UIViewController = storyboard.instantiateViewController(withIdentifier: "TabBar")
        newVc.modalPresentationStyle = .fullScreen
        present(newVc, animated: true, completion: nil)
    }

}


