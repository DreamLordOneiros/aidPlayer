//
//  AIDHandler.swift
//  aid-player
//
//  Created by Javier Hernández on 9/6/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//
import UIKit

class AIDHandler {
    
    static let shared = AIDHandler()
    let defaults = UserDefaults.standard
    
    private init(){}
    
    func isViewed(chapter:String) -> Bool {
        return UserDefaults.standard.bool(forKey: chapter)
    }
    
    func isInProgress(animePath:String) -> Bool {
        return UserDefaults.standard.bool(forKey: animePath)
    }
    
    func showAvailableServers(servers: [String],pathToChapter:String, anime: Anime?, withPresenter presenter:UIViewController) {
        let alert = UIAlertController(title: "Server", message: "Select a server", preferredStyle: .actionSheet)
        
        for item:String in servers {
            alert.addAction(UIAlertAction(title: item, style: .default, handler: { (_) in
                let currentChapter = String(pathToChapter.split(separator: "-").last!)
                let playerVC = AIDPlayerViewController(server: item, chapter: currentChapter)
                UserDefaults.standard.set(true, forKey: pathToChapter)
                let navVC = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
                navVC.pushViewController(playerVC, animated: true)
            }))
        }
        
        if anime != nil {
            alert.addAction(UIAlertAction(title: "Chapters", style: .default, handler: { (_) in
                AIDClient.shared.getAnimeCard(with: anime!.pathToMain, completionHandler: { (card) in
                    UserDefaults.standard.set(true, forKey: anime!.animeName)
                    let mainSerie = ViewController(card: card)
                    let navVC = UIApplication.shared.keyWindow!.rootViewController as! UINavigationController
                    navVC.pushViewController(mainSerie, animated: true)
                })
            }))
        }
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = presenter.view
            popoverController.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        presenter.present(alert, animated: true, completion: {
            print("completion block ... if needed")
        })
    }
    
    func showAvailableServers(servers: [String], chapterPath:String?, withPresenter presenter:UIViewController) {
        showAvailableServers(servers: servers,pathToChapter: chapterPath!, anime: nil, withPresenter: presenter)
    }
}
