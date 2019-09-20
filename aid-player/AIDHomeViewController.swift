//
//  AIDHomeViewController.swift
//  aid-player
//
//  Created by Javier Hernández on 9/3/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire
import SDWebImage

class AIDHomeViewController: UIViewController {
    
    let viewsSpacing:CGFloat = 10.0
    let itemProportion:CGFloat = 140/250
    var weekAnime: [[String:[Anime]]]?
    
    let animeCover: UIImageView = {
        let iV = UIImageView()
        iV.translatesAutoresizingMaskIntoConstraints = false
        iV.sd_setImage(with: URL(string: "https://via.placeholder.com/250x140.png?text=Loading"), completed: nil)
        iV.layer.cornerRadius = 10
        iV.layer.borderWidth = 2
        iV.layer.borderColor = UIColor.themeBlueColor.cgColor
        iV.layer.backgroundColor = UIColor.clear.cgColor
        iV.sizeToFit()
        iV.layer.masksToBounds = true
        return iV
    }()
    
    let animeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Anime Name"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .softThemeColor
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }()
    
    let animeKanjiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Anime Kanji"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    
    let animeSinopsisText: UITextView = {
        let tV = UITextView()
        tV.translatesAutoresizingMaskIntoConstraints = false
        tV.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        tV.textColor = .white
        tV.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        tV.layer.cornerRadius = 10
        tV.layer.borderWidth = 1
        tV.layer.borderColor = UIColor.themeColor.cgColor
        tV.layer.masksToBounds = true
        return tV
    }()
    
    let expandableView: ExpandableView = {
        let exV = ExpandableView()
        return exV
    }()
    
    var weekCollectionView: UICollectionView!
    let weekCell = "dayCellId"
    let headerId = "headerCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupView()
        loadContent()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.white
//        let margin = view.layoutMarginsGuide
//        view.addSubview(animeCover)
//        view.addSubview(animeNameLabel)
//        view.addSubview(animeKanjiLabel)
//        view.addSubview(animeSinopsisText)
        view.addSubview(expandableView)
        view.addSubview(weekCollectionView)
        title = "AID Home"
        
//        NSLayoutConstraint.activate([
//            animeNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: viewsSpacing),
//            animeNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: viewsSpacing),
//            animeNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -viewsSpacing),
//            animeNameLabel.heightAnchor.constraint(equalToConstant: 20)
//            ])
//
//        NSLayoutConstraint.activate([
//            animeKanjiLabel.topAnchor.constraint(equalTo: animeNameLabel.bottomAnchor, constant: viewsSpacing),
//            animeKanjiLabel.leftAnchor.constraint(equalTo: animeCover.rightAnchor, constant: viewsSpacing),
//            animeKanjiLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -viewsSpacing),
//            animeKanjiLabel.heightAnchor.constraint(equalToConstant: 16)
//            ])
//
//        NSLayoutConstraint.activate([
//            animeSinopsisText.topAnchor.constraint(equalTo: animeKanjiLabel.bottomAnchor, constant: viewsSpacing),
//            animeSinopsisText.leftAnchor.constraint(equalTo: animeCover.rightAnchor, constant: viewsSpacing),
//            animeSinopsisText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -viewsSpacing),
//            animeSinopsisText.bottomAnchor.constraint(equalTo: animeCover.bottomAnchor, constant: 0)
//            ])
//
//        NSLayoutConstraint.activate([
//            animeCover.topAnchor.constraint(equalTo: animeNameLabel.bottomAnchor, constant: viewsSpacing),
//            animeCover.leftAnchor.constraint(equalTo: view.leftAnchor, constant: viewsSpacing),
//            animeCover.widthAnchor.constraint(equalToConstant: 116),
//            animeCover.heightAnchor.constraint(equalToConstant: 164)
//            ])
        expandableView.heightConstraint = expandableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        
        NSLayoutConstraint.activate([
            expandableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            expandableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            expandableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            expandableView.heightConstraint
            ])
        
        NSLayoutConstraint.activate([
            weekCollectionView.topAnchor.constraint(equalTo: expandableView.bottomAnchor, constant: 8),
            weekCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            weekCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            weekCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -8)
            ])
    }
    
    func setupCollectionView() {
        let itemWidth = (UIDevice.current.userInterfaceIdiom == .phone) ? view.frame.width : view.frame.width / 3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: itemWidth - 20, height: itemWidth * itemProportion)
        
        weekCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        weekCollectionView.register(AIDWeekdayCell.self, forCellWithReuseIdentifier: weekCell)
        weekCollectionView.register(WeekHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        weekCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        weekCollectionView.backgroundColor = .clear
    }
    
    func loadContent() {
        AIDClient.shared.getLastWeekChapters { [unowned self] (week) in
            self.weekAnime = week
            self.weekCollectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weekCollectionView.reloadData()
    }
}

extension AIDHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return weekAnime?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let weekDay = weekAnime![section].first
        let dayElement = weekDay?.value
        return dayElement?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekCell, for: indexPath) as! AIDWeekdayCell
        let element = elementFor(forIndex: indexPath)
        cell.cover.sd_setImage(with: URL(string: element.cover), completed: nil)
        cell.chapterLabel.text = element.animeName
        let progress = AIDHandler.shared.isInProgress(animePath: element.animeName)
        cell.backgroundColor = progress ? UIColor.softThemeBlueColor : .softerThemeColor
        return cell
    }
    
    func elementFor(forIndex index:IndexPath) -> Anime {
        let weekDay = weekAnime![index.section].first
        let element = weekDay?.value
        return element![index.item]
    }
}

extension AIDHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let animeElement = elementFor(forIndex: indexPath)
        AIDClient.shared.getServers(forPath: animeElement.pathToLatest) { [unowned self] servers in
            AIDHandler.shared.showAvailableServers(servers: servers, pathToChapter: animeElement.pathToLatest, anime: animeElement, withPresenter: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! WeekHeaderView
            //do other header related calls or settups
            let title = weekAnime?[indexPath.section].keys.first
            reusableview.headerTitle.text = title
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
}

extension AIDHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 30)
    }
}

class AIDWeekdayCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let chapterLabel: UILabel = {
        let label = UILabel()
        label.text = "chapter"
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    let cover: UIImageView = {
        let iV = UIImageView()
        iV.translatesAutoresizingMaskIntoConstraints = false
        iV.sd_setImage(with: URL(string: "https://via.placeholder.com/250x140.png?text=Loading"), completed: nil)
        iV.layer.cornerRadius = 15
        iV.layer.borderWidth = 1
        iV.layer.borderColor = UIColor.themeBlueColor.cgColor
        iV.layer.backgroundColor = UIColor.clear.cgColor
        iV.sizeToFit()
        iV.layer.masksToBounds = true
        return iV
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
        
        self.addSubview(containerView)
        containerView.addSubview(cover)
        containerView.addSubview(chapterLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            ])
        
        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: containerView.topAnchor),
            cover.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            cover.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            cover.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            chapterLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            chapterLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4),
            chapterLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4),
            chapterLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
