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

  @IBAction func dismiss(sender: UIBarButtonItem) {
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
      presentAppStore()
    case (0, 2):
      presentTwitter()
    case (0, 3):
      presentGithub()
    case (1, 0):
      presentFFWorld()
    case (1, 1):
      presentFFWiki()
    default:break
    }
  }
  
  func presentAppStore() {
    let storeController = SKStoreProductViewController()
    storeController.delegate = self
    storeController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: "981939574"]) { (result: Bool, error: NSError!) -> Void in
      self.presentViewController(storeController, animated: true, completion: nil)
    }
  }
  
  func presentTwitter() {
    let app = UIApplication.sharedApplication()
    if let twitterAppURL = NSURL(string: "twitter://user?screen_name=zedenem") {
      if app.canOpenURL(twitterAppURL) {
        app.openURL(twitterAppURL)
        return
      }
    }
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
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

//