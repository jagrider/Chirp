//
//  TweetDetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jonathan Grider on 2/18/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import ActiveLabel
import AlamofireImage

class TweetDetailViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: ActiveLabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var retweetsLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var favoritesLabel: UILabel!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var hapticFeedback = UIImpactFeedbackGenerator()
  var url: NSURL?
  var tweet: Tweet!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    profileImageView.clipsToBounds = true
    profileImageView.contentMode = .scaleAspectFit
    
    setupTweet()
    
    updateRetweetAndFavorite()
    
    setupColors()
    
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
  
  func setupTweet() {
    if let tweet = tweet {
      tweetTextLabel.text = tweet.text
      tweetTextLabel.URLColor = .twitterBlueColor()
      tweetTextLabel.URLSelectedColor = .twitterBlueColor()
      tweetTextLabel.hashtagColor = .twitterBlueColor()
      tweetTextLabel.mentionColor = .twitterBlueColor()
      tweetTextLabel.handleURLTap { message in
        self.url = message as NSURL
        self.performSegue(withIdentifier: "DetailWebSegue", sender: nil)
      }
      
      favoritesLabel.text = "LIKES"
      retweetsLabel.text = "RETWEETS"
      
      nameLabel.text = tweet.user.name
      usernameLabel.text = "@" + tweet.user.username
      timestampLabel.text = tweet.createdAtString
      
      // Set up profile picture image
      profileImageView.af_setImage(withURL: URL(string: tweet.profileImageString)!)
      profileImageView.layer.cornerRadius = 4
      profileImageView.clipsToBounds = true
    }
  }
  
  func updateRetweetAndFavorite() {
    updateRetweetCount()
    updateFavoriteCount()
    updateRetweetButton()
    updateFavoriteButton()
  }
  
  func updateButton(button: UIButton, selected: Bool?) {
    if let selected = selected {
      button.isSelected = selected
    }
  }
  
  func updateRetweetButton() {
    if tweet.retweeted {
      retweetButton.isSelected = true
      //      retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControlState.selected)
    } else {
      retweetButton.isSelected = false
      //      retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControlState.normal)
    }
  }
  
  func updateFavoriteButton() {
    if tweet.favorited {
      favoriteButton.isSelected = true
      //      favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControlState.selected)
    } else {
      favoriteButton.isSelected = false
      //      favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControlState.normal)
    }
  }
  
  func updateFavoriteCount() {
    favoriteCountLabel.isHidden = (tweet.favoriteCount == 0)
    favoritesLabel.isHidden = (tweet.favoriteCount == 0)
    favoriteCountLabel.text = "\(tweet.favoriteCount)"
  }
  
  func updateRetweetCount() {
    retweetCountLabel.isHidden = (tweet.retweetCount == 0)
    retweetsLabel.isHidden = (tweet.retweetCount == 0)
    retweetCountLabel.text = "\(tweet.retweetCount)"
  }

  @IBAction func pressedFavorite(_ sender: Any) {
    print("Pressed favorite!")
    hapticFeedback.impactOccurred()
    self.favoriteButton.isUserInteractionEnabled = false
    self.retweetButton.isUserInteractionEnabled = false
    if tweet.favorited != true {
      // Update the local tweet model
      tweet.favoriteCount += 1
      tweet.favorited = true
      
      // Update cell UI
      updateRetweetAndFavorite()
      
      // Send a POST request to the POST retweet endpoint
      APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
        if let error = error {
          print("Error favoriting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else {
          //print("Successfully favorited the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
      
    } else {
      // Update the local tweet model
      tweet.favoriteCount -= 1
      tweet.favorited = false
      
      // Update cell UI
      updateRetweetAndFavorite()
      
      // Send a POST request to the POST unretweet endpoint
      APIManager.shared.unfavorite(tweet) { (tweet: Tweet?, error: Error?) in
        if let error = error {
          print("Error unfavoriting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else {
          //print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
      
    }
  }
  
  @IBAction func pressedReply(_ sender: Any) {
    performSegue(withIdentifier: "DetailReplySegue", sender: nil)
  }
  

  @IBAction func pressedRetweet(_ sender: Any) {
    print("Pressed retweet!")
    hapticFeedback.impactOccurred()
    self.retweetButton.isUserInteractionEnabled = false
    self.favoriteButton.isUserInteractionEnabled = false
    if tweet.retweeted != true {
      // Update the local tweet model
      tweet.retweetCount += 1
      tweet.retweeted = true
      
      // Update cell UI
      updateRetweetAndFavorite()
      
      // Send a POST request to the POST favorites/create endpoint
      APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
        if let  error = error {
          print("Error retweeting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else {
          //print("Successfully retweeted the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
      
    } else {
      // Update the local tweet model
      tweet.retweetCount -= 1
      tweet.retweeted = false
      
      // Update cell UI
      updateRetweetAndFavorite()
      
      // Send a POST request to the POST favorites/destroy endpoint
      APIManager.shared.unretweet(tweet) { (tweet: Tweet?, error: Error?) in
        if let error = error {
          print("Error unretweeting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else {
          //print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DetailWebSegue" {
      let destinationNavController = segue.destination as! UINavigationController
      let destination = destinationNavController.topViewController as! WebViewController
      destination.url = self.url
    } else if segue.identifier == "DetailReplySegue" {
      let destinationNavController = segue.destination as! UINavigationController
      let destination = destinationNavController.topViewController as! ComposeViewController
      destination.replying = true
      destination.replyId = "\(tweet.id)"
      destination.newPlaceholder = "Reply to \(self.usernameLabel.text ?? "username")'s Tweet..."
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
