//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
  
  var name: String
  var username: String
  var profileImageURL: String!
  var profileBackgroundImageUrl: String?
  var description: String!
  var followerCount: Int!
  var followingCount: Int!
  var tweetCount: Int!
  
  var dictionary: [String: Any]?
  private static var _current: User?
  
  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
    name = dictionary["name"] as! String
    username = dictionary["screen_name"] as! String
    profileImageURL = dictionary["profile_image_url_https"] as! String
    profileBackgroundImageUrl = dictionary["profile_background_image_url"] as? String
    description = dictionary["description"] as! String
    followerCount = dictionary["followers_count"] as! Int
    followingCount = dictionary["friends_count"] as! Int
    tweetCount = dictionary["statuses_count"] as! Int
  }
  
  static var current: User? {
    get {
      if _current == nil {
        let defaults = UserDefaults.standard
        if let userData = defaults.data(forKey: "currentUserData") {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
          _current = User(dictionary: dictionary)
        }
      }
      return _current
    }
    set (user) {
      _current = user
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.set(data, forKey: "currentUserData")
      } else {
        defaults.removeObject(forKey: "currentUserData")
      }
    }
  }
}
