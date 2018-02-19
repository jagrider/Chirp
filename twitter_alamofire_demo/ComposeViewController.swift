//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Jonathan Grider on 2/19/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

protocol ComposeViewControllerDelegate {
  func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var tweetTextView: KMPlaceholderTextView!
  @IBOutlet weak var characterCountLabel: UILabel!
  
  var delegate: ComposeViewControllerDelegate?
  var tweetTooLong: Bool = false
  var replying: Bool = false
  var replyId: String?
  var newPlaceholder: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let placeholder = newPlaceholder {
      tweetTextView.placeholder = placeholder
    }
    
    tweetTextView.delegate = self
    
    setupColors()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
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
    navigationItem.rightBarButtonItem?.tintColor = .white
  }
  
  @IBAction func didTapTweet(_ sender: Any) {
    
    if tweetTextView.text.count == 0 || tweetTextView.text.count > 140  {
      print("Tweet too long!")
    }
    
    if !replying {
      APIManager.shared.composeTweet(with: tweetTextView.text) { (tweet, error) in
        if let error = error {
          print("Error composing Tweet: \(error.localizedDescription)")
          self.dismiss(animated: true, completion: nil)
        } else if let tweet = tweet {
          self.delegate?.did(post: tweet)
          print("Compose Tweet Success!")
          self.dismiss(animated: true, completion: nil)
        }
      }
    } else if let id = replyId {
      
      APIManager.shared.reply(id: id, text: tweetTextView.text, completion: {(tweet, error) in
        if let error = error {
          print("Error replying to Tweet: \(error.localizedDescription)")
          self.dismiss(animated: true, completion: nil)
        } else if tweet != nil {
          self.dismiss(animated: true, completion: nil)
          print("Reply to tweet successful")
        }
      })
      
      // Reset reply variables
      replying = false
      replyId = nil
      newPlaceholder = nil
    }
    
  }
  
  @IBAction func didTapCancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let currentText = tweetTextView.text ?? ""
    guard let stringRange = Range(range, in: currentText) else { return false }
    let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
    characterCountLabel.text = String(Int(140 - updatedText.count))
    
    updateCharacterCountLabel(count: 140 - updatedText.count)
    
    return updatedText.count < 140 // Change limit based on your requirement.
  }
  
  func updateCharacterCountLabel(count: Int) {
    
    switch count {
    case 0:
      characterCountLabel.textColor = .red
    case 10:
      characterCountLabel.textColor = #colorLiteral(red: 0.9159221343, green: 0.1873795243, blue: 0.09282759355, alpha: 1)
    case 20:
      characterCountLabel.textColor = #colorLiteral(red: 0.8571895836, green: 0.1753640079, blue: 0.08687512101, alpha: 1)
    case 30:
      characterCountLabel.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    case 50:
      characterCountLabel.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    case 80:
      characterCountLabel.textColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
    default:
      characterCountLabel.textColor = .black
    }
    
    characterCountLabel.textColor = (count == 0) ? .red : .black
    characterCountLabel.textColor = (count < 80) ? #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1) : .black
    characterCountLabel.textColor = (count < 50) ? #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1) : .black
    characterCountLabel.textColor = (count < 30) ? #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) : .black
    characterCountLabel.textColor = (count < 20) ? #colorLiteral(red: 0.8571895836, green: 0.1753640079, blue: 0.08687512101, alpha: 1) : .black
    characterCountLabel.textColor = (count < 10) ? #colorLiteral(red: 0.9159221343, green: 0.1873795243, blue: 0.09282759355, alpha: 1) : .black
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
