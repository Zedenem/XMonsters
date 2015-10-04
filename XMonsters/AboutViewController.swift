//
//  AboutViewController.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 6/13/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import UIKit
import StoreKit

class AboutViewController: UITableViewController {
  
  @IBOutlet weak var aboutLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Flurry.logEvent("about", timed: true)
  }

  @IBAction func dismiss(sender: UIBarButtonItem) {
    Flurry.endTimedEvent("about", withParameters: nil)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.section == 0 && indexPath.row == 0 {
      aboutLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame)
      let height = aboutLabel.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 40
      return height
    }
    return UITableViewAutomaticDimension
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    switch (indexPath.section, indexPath.row) {
    case (0, 1):
      Flurry.logEvent("select_app_store")
      presentAppStore()
    case (0, 2):
      Flurry.logEvent("select_twitter")
      presentTwitter()
    case (0, 3):
      Flurry.logEvent("present_github")
      presentGithub()
    case (1, 0):
      Flurry.logEvent("present_ffworld")
      presentFFWorld()
    case (1, 1):
      Flurry.logEvent("present_ffwiki")
      presentFFWiki()
    default:break
    }
  }
  
  func presentAppStore() {
    Flurry.logEvent("present_app_store")
    UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/app/id981939574")!)
  }
  
  func presentTwitter() {
    let app = UIApplication.sharedApplication()
    if let twitterAppURL = NSURL(string: "twitter://user?screen_name=zedenem") {
      if app.canOpenURL(twitterAppURL) {
        Flurry.logEvent("present_twitter_app")
        app.openURL(twitterAppURL)
        return
      }
    }
    Flurry.logEvent("present_twitter_web")
    app.openURL(NSURL(string: "https://twitter.com/zedenem")!)
  }
  
  func presentGithub() {
    UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/Zedenem/XMonsters")!)
  }
  
  func presentFFWorld() {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://www.ffworld.com/?rub=ff10&page=q_arene")!)
  }
  
  func presentFFWiki() {
    UIApplication.sharedApplication().openURL(NSURL(string: "http://finalfantasy.wikia.com/wiki/Monster_Arena")!)
  }
}

extension AboutViewController: SKStoreProductViewControllerDelegate {
  func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
    Flurry.endTimedEvent("present_app_store", withParameters: nil)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}