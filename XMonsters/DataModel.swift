//
//  DataModel.swift
//  XMonsters
//
//  Created by Zouhair Mahieddine on 3/31/15.
//  Copyright (c) 2015 Zedenem. All rights reserved.
//

import Foundation

class Area {
  let name: String
  var monsters = [Monster]()
  
  init(name: String) {
    self.name = name
  }
  
  convenience init (name: String, monstersNames: [String]) {
    self.init(name: name)
    for monsterName in monstersNames {
      monsters.append(Monster(name: monsterName))
    }
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

class AreasController {
  lazy var areas: [Area] = {
    var areas = [Area]()
    
    var a = Area(name: NSLocalizedString("Besaid", comment: ""), monstersNames: ["Condor", "Dingo", "Flambos"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Kilika", comment: ""), monstersNames: ["Abeille Tueuse", "Balsamine", "Dinonyx", "Élémentaire Jaune"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Mi'ihen Highroad", comment: ""), monstersNames: ["Bicorne", "Bombo", "Chien de Mi'ihen", "Cujo", "Élémentaire Blanc", "Ipiria", "Oeil Flottant", "Vouivre"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Mushroom Rock Road", comment: ""), monstersNames: ["Élémentaire Rouge", "Flambos de Foudre", "Fungus", "Gandharva", "Garuda", "Lamashtu", "Raptour"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Djose Road", comment: ""), monstersNames: ["Basilisk", "Bunyips", "Emildea", "Flambos de Neige", "Garoum", "Ochu", "Simurgh"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Thunder Plains", comment: ""), monstersNames: ["Aroj", "Buer", "Ekarissor", "Élémentaire Or", "Kusarique", "Larva", "Mélusine", "Pampa"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Macalania", comment: ""), monstersNames: ["Loup des Neiges", "Iguanore", "Guêpe", "Oeil Démoniaque", "Flambos de Glace", "Élémentaire Bleu", "Mulfus", "Mafut", "Koospos", "Chimaira"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Bikanel", comment: ""), monstersNames: ["Loup des Sables", "Alcyon", "Mushussu", "Zu", "Ver des Sables", "Pampa"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Calm Lands", comment: ""), monstersNames: ["Lycaon", "Nebiros", "Flambos de Feu", "Shred", "Vipère-méduse", "Ogre", "Couguar", "Kimaira", "Xylomid"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Stolen Fayth Cavern", comment: ""), monstersNames: ["Yowie", "Galkimasera", "Élémentaire Obscur", "Nidhog", "Thorn", "Varaha", "Epehj", "Fantôme", "Tomberry"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Mt. Gagazet", comment: ""), monstersNames: ["Bandersnatch", "Ahriman", "Flambos Noir", "Grenada", "Orchida", "Grendel", "Asherah", "Mandragore", "Behemoth", "Serrasalmus", "Achelus", "Barracudo Cornu"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Inside Sin", comment: ""), monstersNames: ["Exoray", "Spectre", "Gemini A", "Gemini B", "Démonolithe", "Morbol", "Barbatos", "Adamankhelone", "Méga Behemoth"])
    areas.append(a)
    
    a = Area(name: NSLocalizedString("Omega Dungeon", comment: ""), monstersNames: ["Zaurus", "Oeil de la Mort", "Élémentaire Noir", "Haarma", "Pyrobolse", "Esprit", "Métillé", "Maître Couguar", "Tomberry Nion", "Varuna"])
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