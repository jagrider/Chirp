//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate {
  
  func did(post: Tweet) {
    tweets = [post] + tweets
    tableView.reloadData()
  }
  
  var tweets: [Tweet] = []
  let logoutAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
  var refreshControl: UIRefreshControl!
  var loadingMoreView: InfiniteScrollActivityView?
  var dataLoading: Bool = false
  var url: NSURL?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up UI colors
    setupColors()
    
    // Set up alert controllers
    setupAlerts()
    
    // Set up table view
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    // Set up Infinite Scroll loading indicator
    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
    loadingMoreView = InfiniteScrollActivityView(frame: frame)
    loadingMoreView!.isHidden = true
    tableView.addSubview(loadingMoreView!)
    var insets = tableView.contentInset
    insets.bottom += InfiniteScrollActivityView.defaultHeight
    tableView.contentInset = insets
    
    // Add refresh controller
    self.refreshControl = UIRefreshControl()
    self.refreshControl?.addTarget(self, action: #selector(getTimeline), for: .valueChanged)
    self.tableView.addSubview(refreshControl)
    
    // Get next 20 tweets
    getTimeline()
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    
    cell.tweet = tweets[indexPath.row]
    cell.delegate = self
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func didTapLogout(_ sender: Any) {
    present(logoutAlert, animated: true) {
      // If they tap Logout, let the API handler log them out.
    }
  }
  
  // Set up UIAlertControllers
  func setupAlerts() {
    // Set up logout alert controller
    let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (action) in
      APIManager.shared.logout()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      // Do nothing; dismisses the view
    }
    logoutAlert.addAction(logoutAction)
    logoutAlert.addAction(cancelAction)
    
  }
  
  func setupColors() {
    setupNavigationBar()
  }
  
  func setupNavigationBar() {
    // TODO: Set up dark mode
    // if darkMode {
    //    stuff
    // } else {
    //    darker stuff
    // }
    
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
  
  // Update the tweets timeline
  func getTimeline() {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
      // Stop the refresh controller
      self.refreshControl.endRefreshing()
    }
    
    APIManager.shared.getHomeTimeLine(withMaxId: nil) { (tweets, error) in
      if let tweets = tweets {
        
        // TODO: figure this out
//        // If we already have tweets loaded, we shouldn't load them again
//        // We'll just add the new ones.
//        if self.tweets.count > 0 {
//          for tweet in tweets.reversed() {
//            for actualTweet in self.tweets {
//              if !self.tweets.contains(where: { _ in tweet.id == actualTweet.id }) {
//                self.tweets.insert(tweet, at: 0)
//                break
//              }
//            }
//          }
//        } else {
//          self.tweets = tweets
//        }
        
        self.tweets = tweets
        self.tableView.reloadData()
        self.dataLoading = false
      } else if let error = error {
        print("Error getting home timeline: " + error.localizedDescription)
      }
    }
  }
  
  // Infinite Scrolling
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !dataLoading {
      let scrollviewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollviewContentHeight - tableView.bounds.height
      if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
        // We are loading data
        dataLoading = true
        
        // Update position of loadingMoreView, and start loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
                
        APIManager.shared.getHomeTimeLine(withMaxId: tweets.last?.id) { (tweets, error) in
          if let tweets = tweets {
            
            // Update the tableView
            self.tweets.remove(at: self.tweets.count - 1)   // Remove the last one to eliminate overlap
            self.tweets += tweets
            self.tableView.reloadData()
            
            // We are done loading data
            self.dataLoading = false
            
            // Stop the loading indicator
            self.loadingMoreView!.stopAnimating()
          } else if let error = error {
            print(error.localizedDescription)
          }
        }
      }
    }
  }
  
  func didTapUrl(url: NSURL) {
    self.url = url
    performSegue(withIdentifier: "WebViewSegue", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DetailSegue" {
      let cell = sender as! UITableViewCell
      if let indexPath = tableView.indexPath(for: cell) {
        let tweet = tweets[indexPath.row]
        let destination = segue.destination as! TweetDetailViewController
        destination.tweet = tweet
      }
    } else if segue.identifier == "ComposeSegue" {
      let destinationNavController = segue.destination as! UINavigationController
      let destination = destinationNavController.topViewController as! ComposeViewController
      destination.delegate = self
    } else if segue.identifier == "WebViewSegue" {
      let destinationNavController = segue.destination as! UINavigationController
      let destination = destinationNavController.topViewController as! WebViewController
      destination.url = self.url
    }
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
