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
        toggleSize = !toggleSize
        heightConstraint.constant = toggleSize ? 200 : 20
        
        UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
//        UIView.animate(withDuration: 3) { [unowned self] in
//            self.layoutIfNeeded()
//        }
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
    
}
