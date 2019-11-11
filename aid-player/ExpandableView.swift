//
//  ExpandableView.swift
//  aid-player
//
//  Created by Javier Hernández on 9/5/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit

class ExpandableView: UIView {
    
    var heightConstraint:NSLayoutConstraint!
    var toggleSize = false
    weak var presenter: AIDHomeViewController?
    
    let toggleButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.layer.borderColor = UIColor.red.cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("!", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(toggleButton)
        
        toggleButton.addTarget(self, action: Selector(("expand")), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            toggleButton.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            toggleButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 5),
            toggleButton.widthAnchor.constraint(equalToConstant: 22),
            toggleButton.heightAnchor.constraint(equalTo: toggleButton.widthAnchor)
            ])
        
        backgroundColor = .blue
//        let tapGesture = UITapGestureRecognizer(target: self, action: Selector(("expand")))
//        self.addGestureRecognizer(tapGesture)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func expand() {
        // Code To Expand/Collapse
//        toggleSize = !toggleSize
//        heightConstraint.constant = toggleSize ? 200 : 20
//
//        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
//            self.layoutIfNeeded()
//        }, completion: nil)
        showAlertWithTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExpandableView {
    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    /**
    Simple Alert with Text input
    */
    func showAlertWithTextField() {
        let alertController = UIAlertController(title: "Anime to show", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Show", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let animeName = txtField.text {
                // operations
                print("Text==>" + animeName)
                AIDClient.shared.getAnimeCard(with: "/" + animeName, completionHandler: { (card) in
//                    UserDefaults.standard.set(true, forKey: anime!.animeName)
                    let mainSerie = ViewController(card: card)
                    let navVC = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
                    navVC.pushViewController(mainSerie, animated: true)
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Tag"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        presenter!.present(alertController, animated: true, completion: nil)
    }
}
