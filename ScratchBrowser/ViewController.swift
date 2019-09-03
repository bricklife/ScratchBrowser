//
//  ViewController.swift
//  ScratchBrowser
//
//  Created by Shinichiro Oba on 24/02/2019.
//  Copyright © 2019 bricklife.com. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let scale: Double = 0.5
//        let source: String = "var meta = document.createElement('meta');" +
//            "meta.name = 'viewport';" +
//            //"meta.content = 'width=device-width, initial-scale=\(scale), maximum-scale=\(scale), user-scalable=no';" +
//            "meta.content = 'width=device-width, initial-scale=\(scale), user-scalable=no';" +
//            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
//        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        webView.configuration.userContentController.addUserScript(script)
        
        webView.scrollView.isScrollEnabled = false
        
        let url = URL(string: "https://scratch.mit.edu/projects/editor/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
