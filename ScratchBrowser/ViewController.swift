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
        
        let url = URL(string: "https://scratch.mit.edu/projects/editor/")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
