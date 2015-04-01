//
//  DataModel.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import Foundation

func LocalizedString(key: String) -> String {
  return NSLocalizedString(key, comment: key)
}

class AreaController {
  lazy var areas: [Area] = {
    var areas = [Area]()
    
    var a = Area(name: LocalizedString("Besaid"))
    a.monsters.append(Monster(name: LocalizedString("Condor")))
    a.monsters.append(Monster(name: LocalizedString("Dingo")))
    a.monsters.append(Monster(name: LocalizedString("Flambos")))
    areas.append(a)
    
    a = Area(name: LocalizedString("Kilika"))
    a.monsters.append(Monster(name: LocalizedString("Abeille Tueuse")))
    a.monsters.append(Monster(name: LocalizedString("Balsamine")))
    a.monsters.append(Monster(name: LocalizedString("Dinonyx")))
    a.monsters.append(Monster(name: LocalizedString("Élémentaire Jaune")))
    areas.append(a)
    
    return areas
  }()
  
  func save() {
    for a in areas {
      for m in a.monsters {
        m.save()
      }
    }
  }
}

class Area {
  let name: String
  var monsters = [Monster]()
  
  init(name: String) {
    self.name = name
  }
  
  func numberOfCapturedMonsters() -> Int {
    let capturedMonsters = monsters.filter { $0.captured == maxCaptured }
    return capturedMonsters.count
  }
}

let minCaptured = 0
let maxCaptured = 10

class Monster {
  let name: String
  var captured: Int {
    willSet {
      self.captured = max(minCaptured, min(maxCaptured, newValue))
      save()
    }
  }
  
  init(name: String) {
    self.name = name
    if let captured = NSUserDefaults.standardUserDefaults().valueForKey(name) as? Int {
      self.captured = captured
    }
    else {
      self.captured = minCaptured
    }
  }
  
  func save() {
    NSUserDefaults.standardUserDefaults().setValue(captured, forKey: name)
  }
}