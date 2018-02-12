//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage
import TTTAttributedLabel

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: TTTAttributedLabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  
  
  
  var tweet: Tweet! {
    didSet {
      tweetTextLabel.text = tweet.text
      nameLabel.text = tweet.user.name
      usernameLabel.text = "@" + tweet.user.username
      timestampLabel.text = tweet.createdAtString
      
      // Set up profile picture image
      profileImageView.af_setImage(withURL: URL(string: tweet.profileImageString)!)
      profileImageView.layer.cornerRadius = 4
      profileImageView.clipsToBounds = true
      
      updateRetweetAndFavorite()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
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
    favoriteCountLabel.text = "\(tweet.favoriteCount)"
  }
  
  func updateRetweetCount() {
    retweetCountLabel.isHidden = (tweet.retweetCount == 0)
    retweetCountLabel.text = "\(tweet.retweetCount)"
  }
  
  @IBAction func pressedFavorite(_ sender: Any) {
    print("Pressed favorite!")
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
        if let  error = error {
          print("Error favoriting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else if let tweet = tweet {
          print("Successfully favorited the following Tweet: \n\(tweet.text)")
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
        if let  error = error {
          print("Error unfavoriting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else if let tweet = tweet {
          print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
      
    }
  }
  
  
  @IBAction func pressedRetweet(_ sender: Any) {
    print("Pressed retweet!")
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
        } else if let tweet = tweet {
          print("Successfully retweeted the following Tweet: \n\(tweet.text)")
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
        if let  error = error {
          print("Error unretweeting tweet: \(error.localizedDescription)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
        } else if let tweet = tweet {
          print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
          self.retweetButton.isUserInteractionEnabled = true
          self.favoriteButton.isUserInteractionEnabled = true
          //self.tweet = tweet
        }
      }
    }
    
  }
}
