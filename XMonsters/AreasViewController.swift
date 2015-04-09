//
//  AreasViewController.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import UIKit

class AreasViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  let areasController = AreasController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
    areasController.save()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let monstersViewController = segue.destinationViewController as MonstersViewController
    monstersViewController.area = areasController.areas[tableView.indexPathForSelectedRow()!.row]
  }

}

extension AreasViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return areasController.areas.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("AreaCell") as UITableViewCell
    
    let area = areasController.areas[indexPath.row]
    cell.textLabel!.text! = area.name
    cell.detailTextLabel!.text! = "\(area.numberOfCapturedMonsters()) / \(area.monsters.count)"
    
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

