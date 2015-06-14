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
  var monsters : [Monster]
  
  init(name: String, monsters: [Monster]) {
    self.name = name
    self.monsters = monsters
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
  let key: String
  var captured: Int {
    willSet {
      self.captured = max(minCaptured, min(maxCaptured, newValue))
      save()
    }
  }
  
  init(name: String, key: String) {
    self.name = name
    self.key = key
    if let captured = NSUserDefaults.standardUserDefaults().valueForKey(key) as? Int {
      self.captured = captured
    }
    else {
      self.captured = minCaptured
    }
  }
  
  func save() {
    NSUserDefaults.standardUserDefaults().setValue(captured, forKey: key)
  }
}

class AreasController {
  lazy var areas: [Area] = {
    var areas = [Area]()
    
    var monsters = [Monster(name: NSLocalizedString("Condor", comment: ""), key: "Condor"),
                    Monster(name: NSLocalizedString("Dingo", comment: ""), key: "Dingo"),
                    Monster(name: NSLocalizedString("Flambos d'eau", comment: ""), key: "Flambos")]
    var a = Area(name: NSLocalizedString("Besaid", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Abeille Tueuse", comment: ""), key: "Abeille Tueuse"),
                Monster(name: NSLocalizedString("Balsamine", comment: ""), key: "Balsamine"),
                Monster(name: NSLocalizedString("Dinonyx", comment: ""), key: "Dinonyx"),
                Monster(name: NSLocalizedString("Élémentaire Jaune", comment: ""), key: "Élémentaire Jaune")]
    a = Area(name: NSLocalizedString("Kilika", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Bicorne", comment: ""), key: "Bicorne"),
                Monster(name: NSLocalizedString("Bombo", comment: ""), key: "Bombo"),
                Monster(name: NSLocalizedString("Chien de Mi'ihen", comment: ""), key: "Chien de Mi'ihen"),
                Monster(name: NSLocalizedString("Cujo", comment: ""), key: "Cujo"),
                Monster(name: NSLocalizedString("Élémentaire Blanc", comment: ""), key: "Élémentaire Blanc"),
                Monster(name: NSLocalizedString("Ipiria", comment: ""), key: "Ipiria"),
                Monster(name: NSLocalizedString("Oeil Flottant", comment: ""), key: "Oeil Flottant"),
                Monster(name: NSLocalizedString("Vouivre", comment: ""), key: "Vouivre")]
    a = Area(name: NSLocalizedString("Mi'ihen Highroad", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Élémentaire Rouge", comment: ""), key: "Élémentaire Rouge"),
                Monster(name: NSLocalizedString("Flambos de Foudre", comment: ""), key: "Flambos de Foudre"),
                Monster(name: NSLocalizedString("Fungus", comment: ""), key: "Fungus"),
                Monster(name: NSLocalizedString("Gandharva", comment: ""), key: "Gandharva"),
                Monster(name: NSLocalizedString("Garuda", comment: ""), key: "Garuda"),
                Monster(name: NSLocalizedString("Lamashtu", comment: ""), key: "Lamashtu"),
                Monster(name: NSLocalizedString("Raptour", comment: ""), key: "Raptour")]
    a = Area(name: NSLocalizedString("Mushroom Rock Road", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Basilisk", comment: ""), key: "Basilisk"),
                Monster(name: NSLocalizedString("Bunyips", comment: ""), key: "Bunyips"),
                Monster(name: NSLocalizedString("Elmidea", comment: ""), key: "Emildea"),
                Monster(name: NSLocalizedString("Flambos de Neige", comment: ""), key: "Flambos de Neige"),
                Monster(name: NSLocalizedString("Garoum", comment: ""), key: "Garoum"),
                Monster(name: NSLocalizedString("Ochu", comment: ""), key: "Ochu"),
                Monster(name: NSLocalizedString("Simurgh", comment: ""), key: "Simurgh")]
    a = Area(name: NSLocalizedString("Djose Road", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Aroj", comment: ""), key: "Aroj"),
                Monster(name: NSLocalizedString("Buer", comment: ""), key: "Buer"),
                Monster(name: NSLocalizedString("Ekarissor", comment: ""), key: "Ekarissor"),
                Monster(name: NSLocalizedString("Élémentaire Or", comment: ""), key: "Élémentaire Or"),
                Monster(name: NSLocalizedString("Kusarique", comment: ""), key: "Kusarique"),
                Monster(name: NSLocalizedString("Larva", comment: ""), key: "Larva"),
                Monster(name: NSLocalizedString("Mélusine", comment: ""), key: "Mélusine"),
                Monster(name: NSLocalizedString("Pampa ?", comment: ""), key: "Pampa ?")]
    a = Area(name: NSLocalizedString("Thunder Plains", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Loup des Neiges", comment: ""), key: "Loup des Neiges"),
                Monster(name: NSLocalizedString("Iguanor", comment: ""), key: "Iguanore"),
                Monster(name: NSLocalizedString("Guêpe", comment: ""), key: "Guêpe"),
                Monster(name: NSLocalizedString("Oeil Démoniaque", comment: ""), key: "Oeil Démoniaque"),
                Monster(name: NSLocalizedString("Flambos de Glace", comment: ""), key: "Flambos de Glace"),
                Monster(name: NSLocalizedString("Élémentaire Bleu", comment: ""), key: "Élémentaire Bleu"),
                Monster(name: NSLocalizedString("Mulfus", comment: ""), key: "Mulfus"),
                Monster(name: NSLocalizedString("Mafut", comment: ""), key: "Mafut"),
                Monster(name: NSLocalizedString("Koospos", comment: ""), key: "Koospos"),
                Monster(name: NSLocalizedString("Chimaira", comment: ""), key: "Chimaira")]
    a = Area(name: NSLocalizedString("Macalania", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Loup des Sables", comment: ""), key: "Loup des Sables"),
                Monster(name: NSLocalizedString("Alcyon", comment: ""), key: "Alcyon"),
                Monster(name: NSLocalizedString("Mushussu", comment: ""), key: "Mushussu"),
                Monster(name: NSLocalizedString("Zu", comment: ""), key: "Zu"),
                Monster(name: NSLocalizedString("Ver des Sables", comment: ""), key: "Ver des Sables"),
                Monster(name: NSLocalizedString("Pampa", comment: ""), key: "Pampa")]
    a = Area(name: NSLocalizedString("Bikanel", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Lycaon", comment: ""), key: "Lycaon"),
                Monster(name: NSLocalizedString("Nebiros", comment: ""), key: "Nebiros"),
                Monster(name: NSLocalizedString("Flambos de Feu", comment: ""), key: "Flambos de Feu"),
                Monster(name: NSLocalizedString("Shred", comment: ""), key: "Shred"),
                Monster(name: NSLocalizedString("Vipère-méduse", comment: ""), key: "Vipère-méduse"),
                Monster(name: NSLocalizedString("Ogre", comment: ""), key: "Ogre"),
                Monster(name: NSLocalizedString("Couguar", comment: ""), key: "Couguar"),
                Monster(name: NSLocalizedString("Kimaira", comment: ""), key: "Kimaira"),
                Monster(name: NSLocalizedString("Xylomid", comment: ""), key: "Xylomid")]
    a = Area(name: NSLocalizedString("Calm Lands", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Yowie", comment: ""), key: "Yowie"),
                Monster(name: NSLocalizedString("Galkimasera", comment: ""), key: "Galkimasera"),
                Monster(name: NSLocalizedString("Élémentaire Obscur", comment: ""), key: "Élémentaire Obscur"),
                Monster(name: NSLocalizedString("Nidhog", comment: ""), key: "Nidhog"),
                Monster(name: NSLocalizedString("Thorn", comment: ""), key: "Thorn"),
                Monster(name: NSLocalizedString("Varaha", comment: ""), key: "Varaha"),
                Monster(name: NSLocalizedString("Epehj", comment: ""), key: "Epehj"),
                Monster(name: NSLocalizedString("Fantôme", comment: ""), key: "Fantôme"),
                Monster(name: NSLocalizedString("Tomberry", comment: ""), key: "Tomberry")]
    a = Area(name: NSLocalizedString("Stolen Fayth Cavern", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Bandersnatch", comment: ""), key: "Bandersnatch"),
                Monster(name: NSLocalizedString("Ahriman", comment: ""), key: "Ahriman"),
                Monster(name: NSLocalizedString("Flambos Noir", comment: ""), key: "Flambos Noir"),
                Monster(name: NSLocalizedString("Grenada", comment: ""), key: "Grenada"),
                Monster(name: NSLocalizedString("Orchida", comment: ""), key: "Orchida"),
                Monster(name: NSLocalizedString("Grendel", comment: ""), key: "Grendel"),
                Monster(name: NSLocalizedString("Asherah", comment: ""), key: "Asherah"),
                Monster(name: NSLocalizedString("Mandragore", comment: ""), key: "Mandragore"),
                Monster(name: NSLocalizedString("Behemoth", comment: ""), key: "Behemoth"),
                Monster(name: NSLocalizedString("Serrasalmus", comment: ""), key: "Serrasalmus"),
                Monster(name: NSLocalizedString("Achelus", comment: ""), key: "Achelus"),
                Monster(name: NSLocalizedString("Barracuda Cornu", comment: ""), key: "Barracudo Cornu")]
    a = Area(name: NSLocalizedString("Mt. Gagazet", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Exoray", comment: ""), key: "Exoray"),
                Monster(name: NSLocalizedString("Spectre", comment: ""), key: "Spectre"),
                Monster(name: NSLocalizedString("Gemini (Épée)", comment: ""), key: "Gemini A"),
                Monster(name: NSLocalizedString("Gemini (Masse)", comment: ""), key: "Gemini B"),
                Monster(name: NSLocalizedString("Démonolithe", comment: ""), key: "Démonolithe"),
                Monster(name: NSLocalizedString("Morbol", comment: ""), key: "Morbol"),
                Monster(name: NSLocalizedString("Barbatos", comment: ""), key: "Barbatos"),
                Monster(name: NSLocalizedString("Adamankhelone", comment: ""), key: "Adamankhelone"),
                Monster(name: NSLocalizedString("Méga Behemoth", comment: ""), key: "Méga Behemoth")]
    a = Area(name: NSLocalizedString("Inside Sin", comment: ""), monsters: monsters)
    areas.append(a)
    
    monsters = [Monster(name: NSLocalizedString("Zaurus", comment: ""), key: "Zaurus"),
                Monster(name: NSLocalizedString("Oeil de la Mort", comment: ""), key: "Oeil de la Mort"),
                Monster(name: NSLocalizedString("Élémentaire Noir", comment: ""), key: "Élémentaire Noir"),
                Monster(name: NSLocalizedString("Haarma", comment: ""), key: "Haarma"),
                Monster(name: NSLocalizedString("Pyrobolse", comment: ""), key: "Pyrobolse"),
                Monster(name: NSLocalizedString("Esprit", comment: ""), key: "Esprit"),
                Monster(name: NSLocalizedString("Métillé", comment: ""), key: "Métillé"),
                Monster(name: NSLocalizedString("Maître Couguar", comment: ""), key: "Maître Couguar"),
                Monster(name: NSLocalizedString("Tomberry Nion", comment: ""), key: "Tomberry Nion"),
                Monster(name: NSLocalizedString("Varuna", comment: ""), key: "Varuna")]
    a = Area(name: NSLocalizedString("Omega Dungeon", comment: ""), monsters: monsters)
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