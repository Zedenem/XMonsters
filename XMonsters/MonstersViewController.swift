//
//  MonstersViewController.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import UIKit

class MonstersViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var area: Area! {
    willSet {
      title = newValue.name
    }
  }
  
}

extension MonstersViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return area.monsters.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("MonsterCell") as MonsterCell
    cell.delegate = self
    
    let monster = area.monsters[indexPath.row]
    cell.nameLabel.text! = monster.name
    cell.captured = monster.captured
    
    return cell
  }
}

extension MonstersViewController: MonsterCellDelegate {
  func monsterCell(monsterCell: MonsterCell, capturedValueChanged captured: Int) {
    let cellIndex = tableView.indexPathForCell(monsterCell) as NSIndexPath!
    let monster = area.monsters[cellIndex.row]
    monster.captured = captured
  }
}

protocol MonsterCellDelegate {
  func monsterCell(monsterCell: MonsterCell, capturedValueChanged captured: Int)
}

class MonsterCell: UITableViewCell {
  
  var delegate: MonsterCellDelegate!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var capturedLabel: UILabel!
  @IBOutlet weak var capturedStepper: UIStepper!
  
  var captured: Int {
    set {
      capturedStepper.value = Double(newValue)
      capturedLabel.text = "\(newValue)/\(maxCaptured)"
      
      switch newValue {
      case minCaptured:
        capturedLabel.textColor = UIColor.redColor()
      case maxCaptured:
        capturedLabel.textColor = capturedLabel.tintColor
      default:
        capturedLabel.textColor = UIColor.orangeColor()
      }
    }
    get {
      return Int(capturedStepper.value)
    }
  }
  
  @IBAction func capturedStepperValueChanged(sender: AnyObject) {
    captured = Int(capturedStepper.value)
    if let d = delegate {
      d.monsterCell(self, capturedValueChanged: captured)
    }
  }
}