//
//  AreasViewController.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import UIKit
import iAd

class AreasViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  let areasController = AreasController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Flurry.logEvent("areas")
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    loadAdBannerView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    areasController.save()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PushMonstersSegue" {
      let monstersViewController = segue.destinationViewController as! MonstersViewController
      monstersViewController.area = areasController.areas[tableView.indexPathForSelectedRow()!.row]
    }
  }

  //MARK: iAd
  private var adBannerView: ADBannerView!
  private var adBannerViewBottomSpaceLayoutConstraint: NSLayoutConstraint!
}

extension AreasViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return areasController.areas.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AreaCell") as! UITableViewCell
    
    let area = areasController.areas[indexPath.row]
    cell.textLabel!.text = area.name
    cell.detailTextLabel!.text = "\(area.numberOfCapturedMonsters()) / \(area.monsters.count)"
    
    switch area.numberOfCapturedMonsters() {
    case 0:
      cell.detailTextLabel!.textColor = UIColor.redColor()
    case area.monsters.count:
      cell.detailTextLabel!.textColor = cell.detailTextLabel!.tintColor
    default:
      cell.detailTextLabel!.textColor = UIColor.orangeColor()
    }
    
    return cell
  }
}

extension AreasViewController: ADBannerViewDelegate {
  private func loadAdBannerView() {
    Flurry.logEvent("ad_load", timed: true)
    adBannerView = ADBannerView(adType: .Banner)
    adBannerView.delegate = self
    adBannerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    navigationController!.view.addSubview(adBannerView)
    
    let centerConstraint = NSLayoutConstraint(item: adBannerView, attribute: .CenterX, relatedBy: .Equal, toItem: navigationController!.view, attribute: .CenterX, multiplier: 1, constant: 0)
    navigationController!.view.addConstraint(centerConstraint)
    
    adBannerViewBottomSpaceLayoutConstraint = NSLayoutConstraint(item: adBannerView, attribute: .Bottom, relatedBy: .Equal, toItem: navigationController!.bottomLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 50)
    navigationController!.view.addConstraint(adBannerViewBottomSpaceLayoutConstraint)
    
    navigationController!.view.setNeedsUpdateConstraints()
  }
  
  private func showAdBannerView() {
    adBannerViewBottomSpaceLayoutConstraint.constant = 0
    
    view.setNeedsUpdateConstraints()
    UIView.animateWithDuration(1.5) {
      self.view.updateConstraintsIfNeeded()
    }
    
    // Adjust tableView to scroll offset of the Ad
    var contentInset = tableView.contentInset
    contentInset.bottom = CGRectGetHeight(adBannerView.frame)
    tableView.contentInset = contentInset
    tableView.scrollIndicatorInsets = contentInset
  }
  
  private func hideAdBannerView() {
    adBannerViewBottomSpaceLayoutConstraint.constant = CGRectGetHeight(adBannerView.frame)
    
    view.setNeedsUpdateConstraints()
    UIView.animateWithDuration(1.5) {
      self.view.updateConstraintsIfNeeded()
    }
    
    // Adjust tableView not to scroll offset of the Ad anymore
    var contentInset = tableView.contentInset
    contentInset.bottom = 0
    tableView.contentInset = contentInset
    tableView.scrollIndicatorInsets = contentInset
  }
  
  //MARK: AdBannerViewDelegate
  func bannerViewDidLoadAd(banner: ADBannerView!) {
    Flurry.endTimedEvent("ad_load", withParameters: ["success": 1])
    showAdBannerView()
  }
  
  func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    Flurry.endTimedEvent("ad_load", withParameters: ["success": 0])
    Flurry.logError("ad_load_fail", message: error.localizedDescription, error: error)
    hideAdBannerView()
  }
  
  func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
    Flurry.logEvent("present_ad", timed: true)
    return true
  }
  
  func bannerViewActionDidFinish(banner: ADBannerView!) {
    Flurry.endTimedEvent("present_ad", withParameters: nil)
  }
}

