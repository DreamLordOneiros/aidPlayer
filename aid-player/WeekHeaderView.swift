//
//  WeekHeaderView.swift
//  aid-player
//
//  Created by Javier Hernández on 9/3/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit

class WeekHeaderView: UICollectionReusableView {
    
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.softThemeBlueColor
        label.textAlignment = .right
        label.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
    }
    
    func setupViews() {
        addSubview(headerTitle)
        let spacing:CGFloat = 5
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            headerTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),
            headerTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spacing),
            headerTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spacing)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
