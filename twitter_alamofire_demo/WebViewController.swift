//
//  WebViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jonathan Grider on 2/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
  
  var webView: WKWebView!
  var url: NSURL?
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.uiDelegate = self
    webView.navigationDelegate = self
    
    if let url = url {
      let request = NSURLRequest(url: url as URL) as URLRequest
      webView.load(request)
      webView.allowsBackForwardNavigationGestures = true
      
      setupColors()
    }
    
    // Do any additional setup after loading the view.
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupColors() {
    setupNavigationBar()
  }
  
  func setupNavigationBar() {
    
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = .twitterBlueColor()
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
    let twitterTitleLogo = UIImage(named: "TwitterLogo")
    navigationItem.titleView = UIImageView(image: twitterTitleLogo)
    navigationItem.titleView?.contentMode = .scaleAspectFit
    navigationItem.titleView?.clipsToBounds = true
    navigationItem.leftBarButtonItem?.tintColor = .white
    navigationItem.rightBarButtonItem?.tintColor = .white
  }
  
  @IBAction func didPressBack(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
