//
//  UserProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jonathan Grider on 2/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class UserProfileViewController: UIViewController {
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var birthdayLabel: UILabel!
  @IBOutlet weak var taglineLabel: UILabel!
  @IBOutlet weak var tweetsCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up UI Components
    setupProfileViews()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupProfileViews() {
    
    // Temporary
    birthdayLabel.isHidden = true
    locationLabel.isHidden = true
    backgroundImageView.backgroundColor = .twitterBlueColor()
    
    APIManager.shared.getCurrentAccount(completion: {(user, error) in
      if let error = error {
        print(error.localizedDescription)
      } else if let user = user {
        self.usernameLabel.text = "@\(user.username)"
        self.nameLabel.text = user.name
        self.taglineLabel.text = user.description
        self.tweetsCountLabel.text = "\(user.tweetCount ?? 0)"
        self.followersCountLabel.text = "\(user.followerCount ?? 0)"
        self.followingCountLabel.text = "\(user.followingCount ?? 0)"
        self.profileImageView.af_setImage(withURL: URL(string: user.profileImageURL)!)
        if let backgroundString = user.profileBackgroundImageUrl {
          self.backgroundImageView.af_setImage(withURL: URL(string: backgroundString)!)
        }
      }
    })
    
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    profileImageView.clipsToBounds = true
    profileImageView.contentMode = .scaleAspectFit
    
    setupColors()
    
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

  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
