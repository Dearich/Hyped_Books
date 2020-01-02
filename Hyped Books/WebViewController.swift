//
//  WebViewController.swift
//  Hyped Books
//
//  Created by Азизбек on 01.01.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    var uuid: String?
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        webView.navigationDelegate = self
        
        let myURL = URL(string: "https://bookmate.com/books/\(uuid ?? "VVedHgBa")")
        let request = URLRequest(url: myURL!)
        webView.load(request)
    }
    
    fileprivate func showIndicator(show: Bool){
        if show{
            activityIndicator.startAnimating()
        }else{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
   
    
}

extension WebViewController: WKNavigationDelegate{
//MARK: load did Finish
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showIndicator(show: false)
    }
//MARK: load did Start
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.isHidden = false
        self.showIndicator(show: true)
    }
    //MARK: Fail load
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      self.showIndicator(show: false)
    }
    
    
}
