//
//  ViewController.swift
//  aid-player
//
//  Created by Javier Hernández on 8/21/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    
    let viewsSpacing:CGFloat = 10.0
    var anime: AnimeCard?
    
    convenience init() {
        self.init(card: nil)
    }
    
    init(card: AnimeCard?) {
        self.anime = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    let animeCover: UIImageView = {
        let iV = UIImageView()
        iV.translatesAutoresizingMaskIntoConstraints = false
        iV.sd_setImage(with: URL(string: "https://via.placeholder.com/116x164.png?text=Loading"), completed: nil)
        iV.layer.cornerRadius = 10
        iV.layer.borderWidth = 2
        iV.layer.borderColor = UIColor.themeBlueColor.cgColor
        iV.layer.backgroundColor = UIColor.clear.cgColor
        iV.sizeToFit()
        iV.layer.masksToBounds = true
        return iV
    }()
    
    let animeKanjiLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Anime Kanji"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = UIColor.themeBlueColor
        return label
    }()
    
    let animeSinopsisText: UITextView = {
        let tV = UITextView()
        tV.translatesAutoresizingMaskIntoConstraints = false
        tV.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        tV.textColor = UIColor.softThemeBlueColor
        tV.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        tV.layer.cornerRadius = 10
        tV.layer.borderWidth = 1
        tV.layer.borderColor = UIColor.themeColor.cgColor
        tV.layer.masksToBounds = true
        return tV
    }()
    
    var collectionView: UICollectionView!
    let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupView()
        loadContent()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(animeCover)
        view.addSubview(animeKanjiLabel)
        view.addSubview(animeSinopsisText)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            animeKanjiLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: viewsSpacing),
            animeKanjiLabel.leftAnchor.constraint(equalTo: animeCover.rightAnchor, constant: viewsSpacing),
            animeKanjiLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -viewsSpacing),
            animeKanjiLabel.heightAnchor.constraint(equalToConstant: 16)
            ])
        
        NSLayoutConstraint.activate([
            animeSinopsisText.topAnchor.constraint(equalTo: animeKanjiLabel.bottomAnchor, constant: viewsSpacing),
            animeSinopsisText.leftAnchor.constraint(equalTo: animeCover.rightAnchor, constant: viewsSpacing),
            animeSinopsisText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -viewsSpacing),
            animeSinopsisText.bottomAnchor.constraint(equalTo: animeCover.bottomAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            animeCover.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: viewsSpacing),
            animeCover.leftAnchor.constraint(equalTo: view.leftAnchor, constant: viewsSpacing),
            animeCover.widthAnchor.constraint(equalToConstant: 116),
            animeCover.heightAnchor.constraint(equalToConstant: 164)
            ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: animeCover.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
            ])
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: view.frame.width / 3 - 20, height: 60)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(AIDChapterCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    func loadContent() {
        self.animeCover.sd_setImage(with: URL(string: (anime?.cover!)!), completed: nil)
        title = anime?.nameRomani!
        self.animeKanjiLabel.text = anime?.nameKanji!
        self.animeSinopsisText.text = anime?.sinopsis!
        self.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.anime?.chapters.lastChapter ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chapter = "\((anime?.chapters.lastChapter)! - indexPath.row)"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AIDChapterCell
        let chapterPath = "\((anime?.chapters.hRef)!)\(chapter)"
        cell.chapterLabel.text = chapter
        cell.backgroundColor = AIDHandler.shared.isInProgress(animePath: chapterPath) ? .white : .softThemeColor
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pathString = "\(anime?.chapters.hRef ?? "")\((anime?.chapters.lastChapter)! - indexPath.row)"
        AIDClient.shared.getServers(forPath: pathString) { [unowned self] servers in
            AIDHandler.shared.showAvailableServers(servers: servers,chapterPath: pathString, withPresenter: self)
        }
    }
}

class AIDChapterCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.softerThemeColor
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let chapterLabel: UILabel = {
        let label = UILabel()
        label.text = "chapter"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .themeBlueColor
        label.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.softThemeBlueColor
        self.layer.borderColor = UIColor.themeBlueColor.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        self.addSubview(chapterLabel)
        self.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        
        NSLayoutConstraint.activate([
            chapterLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            chapterLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
            chapterLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            chapterLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
            ])
    }
    
    override func prepareForReuse() {
        super .prepareForReuse()
        backgroundColor = UIColor.red
        chapterLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
