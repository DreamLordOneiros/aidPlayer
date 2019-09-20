//
//  AIDPlayerViewController.swift
//  aid-player
//
//  Created by Javier Hernández on 8/23/19.
//  Copyright © 2019 Javier Hernández. All rights reserved.
//

import UIKit
import WebKit

class AIDPlayerViewController: UIViewController {
    
    convenience init() {
        self.init(server: nil, chapter: nil)
    }
    
    init(server: String?, chapter: String?) {
        self.serverString = server
        self.chapter = chapter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    let serverString: String!
    let chapter: String!
    
    var playerWV:WKWebView = {
        let wV = WKWebView()
        wV.backgroundColor = UIColor.softThemeBlueColor
        wV.layer.cornerRadius = 10
        wV.translatesAutoresizingMaskIntoConstraints = false
        wV.layer.masksToBounds = true
        return wV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupCollectionView()
        setupView()
        startPlaying()
//        loadContent()
    }
    
    func setupView() {
        view.backgroundColor = .themeBlueColor
        view.addSubview(playerWV)
        title = chapter
        
        let margin = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            playerWV.topAnchor.constraint(equalTo: margin.topAnchor, constant: 10),
            playerWV.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -10),
            playerWV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            playerWV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
            ])
    }
    
    func startPlaying() {
        playerWV.allowsBackForwardNavigationGestures = false
//        playerWV.navigationDelegate = self
        let url = URL(string: serverString)!
        playerWV.load(URLRequest(url: url))
    }
}

//extension AIDPlayerViewController:WKNavigationDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print(navigationAction.request.url?.absoluteString as! String)
//        var handler = WKNavigationActionPolicy.allow
//        let excludedNavigation = ["game", "deloplen"]
//        for exclusion: String in excludedNavigation {
//            let responseURL = navigationAction.request.url?.absoluteString as! String
//            if (responseURL.contains(exclusion)) {
//                print("fail: \(responseURL)")
//                handler = .cancel
//                break
//            } else {
//                print("pass: \(responseURL)")
//            }
//        }
//        print(handler == .allow ? "pass" : "fail")
//        decisionHandler(handler)
//    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//        var handler = WKNavigationResponsePolicy.allow
//        let excludedNavigation = ["ads", "game"]
//        for exclusion: String in excludedNavigation {
//            let responseURL = navigationResponse.response.url?.absoluteString as! String
//            if (responseURL.contains(exclusion)) {
//                print("fail: \(responseURL)")
//                handler = .cancel
//                break
//            } else {
//                print("pass: \(responseURL)")
//            }
//        }
//        print(handler == .allow ? "pass" : "fail")
//        decisionHandler(handler)
//    }
//}

