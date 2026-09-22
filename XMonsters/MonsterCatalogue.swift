import Foundation

struct ArenaReward: Sendable {
    let item: String
    let unlock: String
    var note: String? = nil
}

/// Verified against Jegged's rewards table on 2026-09-22.
/// English names are explicit until the French item/unlock names are verified.
enum ArenaRewards {
    static let source = URL(string: "https://jegged.com/Games/Final-Fantasy-X/Monster-Arena/Rewards.html")!
    static let zones: [String: ArenaReward] = [
        "besaid": .init(item: "Stamina Tonic ×99", unlock: "Stratoavis"),
        "kilika": .init(item: "Poison Fang ×99", unlock: "Malboro Menace"),
        "mi-ihen-highroad": .init(item: "Soul Spring ×99", unlock: "Kottos"),
        "mushroom-rock-road": .init(item: "Candle of Life ×99", unlock: "Coeurlregina"),
        "djose-road": .init(item: "Petrify Grenade ×99", unlock: "Jormungand"),
        "thunder-plains": .init(item: "Chocobo Wing ×99", unlock: "Cactuar King"),
        "macalania": .init(item: "Shining Gem ×60", unlock: "Espada"),
        "bikanel": .init(item: "Shadow Gem ×99", unlock: "Abyss Worm"),
        "calm-lands": .init(item: "Farplane Wind ×60", unlock: "Chimerageist", note: "Also reveals the Nirvana chest; the Celestial Mirror is required to open it."),
        "stolen-fayth-cavern": .init(item: "Silver Hourglass ×40", unlock: "Don Tonberry"),
        "mt-gagazet": .init(item: "Blossom Crown", unlock: "Catoblepas"),
        "inside-sin": .init(item: "Lunar Curtain ×99", unlock: "Abaddon"),
        "omega-dungeon": .init(item: "Designer Wallet ×60", unlock: "Vorban"),
    ]
    static let families: [String: ArenaReward] = [
        "loups": .init(item: "Chocobo Feather ×99", unlock: "Fenrir"),
        "reptiles": .init(item: "Stamina Spring ×99", unlock: "Ornitholestes"),
        "oiseaux": .init(item: "Mega Phoenix ×99", unlock: "Pteryx"),
        "insectes": .init(item: "Mana Tonic ×60", unlock: "Hornet"),
        "mages-volants": .init(item: "Mana Spring ×99", unlock: "Vidatu"),
        "yeux": .init(item: "Stamina Tablet ×60", unlock: "One-Eye"),
        "flambos": .init(item: "Twin Stars ×60", unlock: "Jumbo Flan"),
        "elementaires": .init(item: "Star Curtain ×99", unlock: "Nega Element"),
        "carapaces": .init(item: "Gold Hourglass ×99", unlock: "Tanket"),
        "dragons": .init(item: "Purifying Salt ×99", unlock: "Fafnir"),
        "champignons": .init(item: "Healing Spring ×99", unlock: "Sleep Sprout"),
        "bombos": .init(item: "Turbo Ether ×60", unlock: "Bomb King"),
        "cornus": .init(item: "Light Curtain ×99", unlock: "Juggernaut"),
        "geants-de-fer": .init(item: "Mana Tablet ×60", unlock: "Ironclad"),
    ]
}

struct CaptureMonster: Identifiable, Sendable {
    // IDs are frozen persistence keys, independent of display names and ordering.
    let id: String
    let frenchName: String
    let localizationKey: String
    let legacyKey: String
    let zoneID: String

    func localizedName(bundle: Bundle = .main) -> String {
        if bundle.preferredLocalizations.first?.hasPrefix("fr") == true { return frenchName }
        return bundle.localizedString(forKey: localizationKey, value: frenchName, table: nil)
    }
}

struct CaptureZone: Identifiable, Sendable {
    let id: String
    let frenchName: String
    let localizationKey: String
}

struct CaptureFamily: Identifiable, Sendable {
    let id: String
    let frenchName: String
    let creationName: String
    let threshold: Int
    let monsterIDs: [String]
}

enum MonsterCatalogue {
    static let captureLimit = 10
    static let zones: [CaptureZone] = [
        .init(id: "besaid", frenchName: "Besaid", localizationKey: "Besaid"),
        .init(id: "kilika", frenchName: "Kilika", localizationKey: "Kilika"),
        .init(id: "mi-ihen-highroad", frenchName: "Route de Mi’ihen", localizationKey: "Mi'ihen Highroad"),
        .init(id: "mushroom-rock-road", frenchName: "Route des Mycorocs", localizationKey: "Mushroom Rock Road"),
        .init(id: "djose-road", frenchName: "Route de Djose", localizationKey: "Djose Road"),
        .init(id: "thunder-plains", frenchName: "Plaine foudroyée", localizationKey: "Thunder Plains"),
        .init(id: "macalania", frenchName: "Macalania", localizationKey: "Macalania"),
        .init(id: "bikanel", frenchName: "Bikanel", localizationKey: "Bikanel"),
        .init(id: "calm-lands", frenchName: "Plaine Félicité", localizationKey: "Calm Lands"),
        .init(id: "stolen-fayth-cavern", frenchName: "Grotte du Priant volé", localizationKey: "Stolen Fayth Cavern"),
        .init(id: "mt-gagazet", frenchName: "Mont Gagazet", localizationKey: "Mt. Gagazet"),
        .init(id: "inside-sin", frenchName: "Sin", localizationKey: "Inside Sin"),
        .init(id: "omega-dungeon", frenchName: "Ruines d’Oméga", localizationKey: "Omega Dungeon"),
    ]

    static let monsters: [CaptureMonster] = [
        .init(id: "dingo", frenchName: "Dingo", localizationKey: "Dingo", legacyKey: "Dingo", zoneID: "besaid"),
        .init(id: "condor", frenchName: "Condor", localizationKey: "Condor", legacyKey: "Condor", zoneID: "besaid"),
        .init(id: "flambos", frenchName: "Flambos d’eau", localizationKey: "Flambos d'eau", legacyKey: "Flambos", zoneID: "besaid"),
        .init(id: "dinonyx", frenchName: "Dinonyx", localizationKey: "Dinonyx", legacyKey: "Dinonyx", zoneID: "kilika"),
        .init(id: "abeille-tueuse", frenchName: "Abeille tueuse", localizationKey: "Abeille Tueuse", legacyKey: "Abeille Tueuse", zoneID: "kilika"),
        .init(id: "elementaire-jaune", frenchName: "Élémentaire jaune", localizationKey: "Élémentaire Jaune", legacyKey: "Élémentaire Jaune", zoneID: "kilika"),
        .init(id: "balsamine", frenchName: "Balsamine", localizationKey: "Balsamine", legacyKey: "Balsamine", zoneID: "kilika"),
        .init(id: "chien-de-mi-ihen", frenchName: "Chien de Mi’ihen", localizationKey: "Chien de Mi'ihen", legacyKey: "Chien de Mi'ihen", zoneID: "mi-ihen-highroad"),
        .init(id: "ipiria", frenchName: "Ipiria", localizationKey: "Ipiria", legacyKey: "Ipiria", zoneID: "mi-ihen-highroad"),
        .init(id: "oeil-flottant", frenchName: "Œil flottant", localizationKey: "Oeil Flottant", legacyKey: "Oeil Flottant", zoneID: "mi-ihen-highroad"),
        .init(id: "elementaire-blanc", frenchName: "Élémentaire blanc", localizationKey: "Élémentaire Blanc", legacyKey: "Élémentaire Blanc", zoneID: "mi-ihen-highroad"),
        .init(id: "cujo", frenchName: "Cujo", localizationKey: "Cujo", legacyKey: "Cujo", zoneID: "mi-ihen-highroad"),
        .init(id: "vouivre", frenchName: "Vouivre", localizationKey: "Vouivre", legacyKey: "Vouivre", zoneID: "mi-ihen-highroad"),
        .init(id: "bombo", frenchName: "Bombo", localizationKey: "Bombo", legacyKey: "Bombo", zoneID: "mi-ihen-highroad"),
        .init(id: "bicorne", frenchName: "Bicorne", localizationKey: "Bicorne", legacyKey: "Bicorne", zoneID: "mi-ihen-highroad"),
        .init(id: "raptour", frenchName: "Raptour", localizationKey: "Raptour", legacyKey: "Raptour", zoneID: "mushroom-rock-road"),
        .init(id: "gandharva", frenchName: "Gandharva", localizationKey: "Gandharva", legacyKey: "Gandharva", zoneID: "mushroom-rock-road"),
        .init(id: "flambos-de-foudre", frenchName: "Flambos de foudre", localizationKey: "Flambos de Foudre", legacyKey: "Flambos de Foudre", zoneID: "mushroom-rock-road"),
        .init(id: "elementaire-rouge", frenchName: "Élémentaire rouge", localizationKey: "Élémentaire Rouge", legacyKey: "Élémentaire Rouge", zoneID: "mushroom-rock-road"),
        .init(id: "lamashtu", frenchName: "Lamashtu", localizationKey: "Lamashtu", legacyKey: "Lamashtu", zoneID: "mushroom-rock-road"),
        .init(id: "fungus", frenchName: "Fungus", localizationKey: "Fungus", legacyKey: "Fungus", zoneID: "mushroom-rock-road"),
        .init(id: "garuda", frenchName: "Garuda", localizationKey: "Garuda", legacyKey: "Garuda", zoneID: "mushroom-rock-road"),
        .init(id: "garoum", frenchName: "Garoum", localizationKey: "Garoum", legacyKey: "Garoum", zoneID: "djose-road"),
        .init(id: "simurgh", frenchName: "Simurgh", localizationKey: "Simurgh", legacyKey: "Simurgh", zoneID: "djose-road"),
        .init(id: "emildea", frenchName: "Elmidea", localizationKey: "Elmidea", legacyKey: "Emildea", zoneID: "djose-road"),
        .init(id: "flambos-de-neige", frenchName: "Flambos de neige", localizationKey: "Flambos de Neige", legacyKey: "Flambos de Neige", zoneID: "djose-road"),
        .init(id: "bunyips", frenchName: "Bunyips", localizationKey: "Bunyips", legacyKey: "Bunyips", zoneID: "djose-road"),
        .init(id: "basilisk", frenchName: "Basilisk", localizationKey: "Basilisk", legacyKey: "Basilisk", zoneID: "djose-road"),
        .init(id: "ochu", frenchName: "Ochu", localizationKey: "Ochu", legacyKey: "Ochu", zoneID: "djose-road"),
        .init(id: "melusine", frenchName: "Mélusine", localizationKey: "Mélusine", legacyKey: "Mélusine", zoneID: "thunder-plains"),
        .init(id: "aroj", frenchName: "Aroj", localizationKey: "Aroj", legacyKey: "Aroj", zoneID: "thunder-plains"),
        .init(id: "buer", frenchName: "Buer", localizationKey: "Buer", legacyKey: "Buer", zoneID: "thunder-plains"),
        .init(id: "elementaire-or", frenchName: "Élémentaire or", localizationKey: "Élémentaire Or", legacyKey: "Élémentaire Or", zoneID: "thunder-plains"),
        .init(id: "kusarique", frenchName: "Kusarique", localizationKey: "Kusarique", legacyKey: "Kusarique", zoneID: "thunder-plains"),
        .init(id: "larva", frenchName: "Larva", localizationKey: "Larva", legacyKey: "Larva", zoneID: "thunder-plains"),
        .init(id: "ekarissor", frenchName: "Ekarissor", localizationKey: "Ekarissor", legacyKey: "Ekarissor", zoneID: "thunder-plains"),
        .init(id: "pampa-question", frenchName: "Pampa ?", localizationKey: "Pampa ?", legacyKey: "Pampa ?", zoneID: "thunder-plains"),
        .init(id: "loup-des-neiges", frenchName: "Loup des neiges", localizationKey: "Loup des Neiges", legacyKey: "Loup des Neiges", zoneID: "macalania"),
        .init(id: "iguanore", frenchName: "Iguanor", localizationKey: "Iguanor", legacyKey: "Iguanore", zoneID: "macalania"),
        .init(id: "guepe", frenchName: "Guêpe", localizationKey: "Guêpe", legacyKey: "Guêpe", zoneID: "macalania"),
        .init(id: "oeil-demoniaque", frenchName: "Œil démoniaque", localizationKey: "Oeil Démoniaque", legacyKey: "Oeil Démoniaque", zoneID: "macalania"),
        .init(id: "flambos-de-glace", frenchName: "Flambos de glace", localizationKey: "Flambos de Glace", legacyKey: "Flambos de Glace", zoneID: "macalania"),
        .init(id: "elementaire-bleu", frenchName: "Élémentaire bleu", localizationKey: "Élémentaire Bleu", legacyKey: "Élémentaire Bleu", zoneID: "macalania"),
        .init(id: "mulfus", frenchName: "Mulfus", localizationKey: "Mulfus", legacyKey: "Mulfus", zoneID: "macalania"),
        .init(id: "mafut", frenchName: "Mafut", localizationKey: "Mafut", legacyKey: "Mafut", zoneID: "macalania"),
        .init(id: "koospos", frenchName: "Koospos", localizationKey: "Koospos", legacyKey: "Koospos", zoneID: "macalania"),
        .init(id: "chimaira", frenchName: "Chimaira", localizationKey: "Chimaira", legacyKey: "Chimaira", zoneID: "macalania"),
        .init(id: "loup-des-sables", frenchName: "Loup des sables", localizationKey: "Loup des Sables", legacyKey: "Loup des Sables", zoneID: "bikanel"),
        .init(id: "alcyon", frenchName: "Alcyon", localizationKey: "Alcyon", legacyKey: "Alcyon", zoneID: "bikanel"),
        .init(id: "mushussu", frenchName: "Mushussu", localizationKey: "Mushussu", legacyKey: "Mushussu", zoneID: "bikanel"),
        .init(id: "zu", frenchName: "Zu", localizationKey: "Zu", legacyKey: "Zu", zoneID: "bikanel"),
        .init(id: "ver-des-sables", frenchName: "Ver des sables", localizationKey: "Ver des Sables", legacyKey: "Ver des Sables", zoneID: "bikanel"),
        .init(id: "pampa", frenchName: "Pampa", localizationKey: "Pampa", legacyKey: "Pampa", zoneID: "bikanel"),
        .init(id: "lycaon", frenchName: "Lycaon", localizationKey: "Lycaon", legacyKey: "Lycaon", zoneID: "calm-lands"),
        .init(id: "nebiros", frenchName: "Nebiros", localizationKey: "Nebiros", legacyKey: "Nebiros", zoneID: "calm-lands"),
        .init(id: "flambos-de-feu", frenchName: "Flambos de feu", localizationKey: "Flambos de Feu", legacyKey: "Flambos de Feu", zoneID: "calm-lands"),
        .init(id: "shred", frenchName: "Shred", localizationKey: "Shred", legacyKey: "Shred", zoneID: "calm-lands"),
        .init(id: "vipere-meduse", frenchName: "Vipère-méduse", localizationKey: "Vipère-méduse", legacyKey: "Vipère-méduse", zoneID: "calm-lands"),
        .init(id: "ogre", frenchName: "Ogre", localizationKey: "Ogre", legacyKey: "Ogre", zoneID: "calm-lands"),
        .init(id: "couguar", frenchName: "Couguar", localizationKey: "Couguar", legacyKey: "Couguar", zoneID: "calm-lands"),
        .init(id: "kimaira", frenchName: "Kimaira", localizationKey: "Kimaira", legacyKey: "Kimaira", zoneID: "calm-lands"),
        .init(id: "xylomid", frenchName: "Xylomid", localizationKey: "Xylomid", legacyKey: "Xylomid", zoneID: "calm-lands"),
        .init(id: "yowie", frenchName: "Yowie", localizationKey: "Yowie", legacyKey: "Yowie", zoneID: "stolen-fayth-cavern"),
        .init(id: "galkimasera", frenchName: "Galkimasera", localizationKey: "Galkimasera", legacyKey: "Galkimasera", zoneID: "stolen-fayth-cavern"),
        .init(id: "elementaire-obscur", frenchName: "Élémentaire obscur", localizationKey: "Élémentaire Obscur", legacyKey: "Élémentaire Obscur", zoneID: "stolen-fayth-cavern"),
        .init(id: "nidhog", frenchName: "Nidhog", localizationKey: "Nidhog", legacyKey: "Nidhog", zoneID: "stolen-fayth-cavern"),
        .init(id: "thorn", frenchName: "Thorn", localizationKey: "Thorn", legacyKey: "Thorn", zoneID: "stolen-fayth-cavern"),
        .init(id: "varaha", frenchName: "Varaha", localizationKey: "Varaha", legacyKey: "Varaha", zoneID: "stolen-fayth-cavern"),
        .init(id: "epehj", frenchName: "Epehj", localizationKey: "Epehj", legacyKey: "Epehj", zoneID: "stolen-fayth-cavern"),
        .init(id: "fantome", frenchName: "Fantôme", localizationKey: "Fantôme", legacyKey: "Fantôme", zoneID: "stolen-fayth-cavern"),
        .init(id: "tomberry", frenchName: "Tomberry", localizationKey: "Tomberry", legacyKey: "Tomberry", zoneID: "stolen-fayth-cavern"),
        .init(id: "bandersnatch", frenchName: "Bandersnatch", localizationKey: "Bandersnatch", legacyKey: "Bandersnatch", zoneID: "mt-gagazet"),
        .init(id: "ahriman", frenchName: "Ahriman", localizationKey: "Ahriman", legacyKey: "Ahriman", zoneID: "mt-gagazet"),
        .init(id: "flambos-noir", frenchName: "Flambos noir", localizationKey: "Flambos Noir", legacyKey: "Flambos Noir", zoneID: "mt-gagazet"),
        .init(id: "grenada", frenchName: "Grenada", localizationKey: "Grenada", legacyKey: "Grenada", zoneID: "mt-gagazet"),
        .init(id: "orchida", frenchName: "Orchida", localizationKey: "Orchida", legacyKey: "Orchida", zoneID: "mt-gagazet"),
        .init(id: "grendel", frenchName: "Grendel", localizationKey: "Grendel", legacyKey: "Grendel", zoneID: "mt-gagazet"),
        .init(id: "asherah", frenchName: "Asherah", localizationKey: "Asherah", legacyKey: "Asherah", zoneID: "mt-gagazet"),
        .init(id: "mandragore", frenchName: "Mandragore", localizationKey: "Mandragore", legacyKey: "Mandragore", zoneID: "mt-gagazet"),
        .init(id: "behemoth", frenchName: "Behemoth", localizationKey: "Behemoth", legacyKey: "Behemoth", zoneID: "mt-gagazet"),
        .init(id: "serrasalmus", frenchName: "Serrasalmus", localizationKey: "Serrasalmus", legacyKey: "Serrasalmus", zoneID: "mt-gagazet"),
        .init(id: "achelus", frenchName: "Achelus", localizationKey: "Achelus", legacyKey: "Achelus", zoneID: "mt-gagazet"),
        .init(id: "barracudo-cornu", frenchName: "Barracuda cornu", localizationKey: "Barracuda Cornu", legacyKey: "Barracudo Cornu", zoneID: "mt-gagazet"),
        .init(id: "exoray", frenchName: "Exoray", localizationKey: "Exoray", legacyKey: "Exoray", zoneID: "inside-sin"),
        .init(id: "spectre", frenchName: "Spectre", localizationKey: "Spectre", legacyKey: "Spectre", zoneID: "inside-sin"),
        .init(id: "gemini-b", frenchName: "Gemini (massue)", localizationKey: "Gemini (Masse)", legacyKey: "Gemini B", zoneID: "inside-sin"),
        .init(id: "gemini-a", frenchName: "Gemini (épée)", localizationKey: "Gemini (Épée)", legacyKey: "Gemini A", zoneID: "inside-sin"),
        .init(id: "demonolithe", frenchName: "Démonolithe", localizationKey: "Démonolithe", legacyKey: "Démonolithe", zoneID: "inside-sin"),
        .init(id: "morbol", frenchName: "Morbol", localizationKey: "Morbol", legacyKey: "Morbol", zoneID: "inside-sin"),
        .init(id: "barbatos", frenchName: "Barbatos", localizationKey: "Barbatos", legacyKey: "Barbatos", zoneID: "inside-sin"),
        .init(id: "adamankhelone", frenchName: "Adamankhelone", localizationKey: "Adamankhelone", legacyKey: "Adamankhelone", zoneID: "inside-sin"),
        .init(id: "mega-behemoth", frenchName: "Méga Behemoth", localizationKey: "Méga Behemoth", legacyKey: "Méga Behemoth", zoneID: "inside-sin"),
        .init(id: "zaurus", frenchName: "Zaurus", localizationKey: "Zaurus", legacyKey: "Zaurus", zoneID: "omega-dungeon"),
        .init(id: "oeil-de-la-mort", frenchName: "Œil de la mort", localizationKey: "Oeil de la Mort", legacyKey: "Oeil de la Mort", zoneID: "omega-dungeon"),
        .init(id: "elementaire-noir", frenchName: "Élémentaire noir", localizationKey: "Élémentaire Noir", legacyKey: "Élémentaire Noir", zoneID: "omega-dungeon"),
        .init(id: "haarma", frenchName: "Haarma", localizationKey: "Haarma", legacyKey: "Haarma", zoneID: "omega-dungeon"),
        .init(id: "pyrobolse", frenchName: "Pyrobolse", localizationKey: "Pyrobolse", legacyKey: "Pyrobolse", zoneID: "omega-dungeon"),
        .init(id: "esprit", frenchName: "Esprit", localizationKey: "Esprit", legacyKey: "Esprit", zoneID: "omega-dungeon"),
        .init(id: "metille", frenchName: "Métillé", localizationKey: "Métillé", legacyKey: "Métillé", zoneID: "omega-dungeon"),
        .init(id: "maitre-couguar", frenchName: "Maître Couguar", localizationKey: "Maître Couguar", legacyKey: "Maître Couguar", zoneID: "omega-dungeon"),
        .init(id: "tomberry-nion", frenchName: "Tomberry Nion", localizationKey: "Tomberry Nion", legacyKey: "Tomberry Nion", zoneID: "omega-dungeon"),
        .init(id: "varuna", frenchName: "Varuna", localizationKey: "Varuna", legacyKey: "Varuna", zoneID: "omega-dungeon"),
    ]

    static let families: [CaptureFamily] = [
        .init(id: "loups", frenchName: "Loups", creationName: "Fenril", threshold: 3, monsterIDs: ["dingo", "chien-de-mi-ihen", "garoum", "loup-des-neiges", "loup-des-sables", "lycaon", "bandersnatch"]),
        .init(id: "reptiles", frenchName: "Reptiles", creationName: "Ornitholestes", threshold: 3, monsterIDs: ["dinonyx", "ipiria", "raptour", "melusine", "iguanore", "yowie", "zaurus"]),
        .init(id: "oiseaux", frenchName: "Oiseaux", creationName: "Pteryx", threshold: 4, monsterIDs: ["condor", "simurgh", "alcyon"]),
        .init(id: "insectes", frenchName: "Insectes", creationName: "Frelon", threshold: 4, monsterIDs: ["abeille-tueuse", "emildea", "guepe", "nebiros"]),
        .init(id: "mages-volants", frenchName: "Mages volants", creationName: "Wizarsha", threshold: 4, monsterIDs: ["gandharva", "aroj", "galkimasera"]),
        .init(id: "yeux", frenchName: "Yeux", creationName: "Lieo Nukan", threshold: 4, monsterIDs: ["oeil-flottant", "buer", "oeil-demoniaque", "ahriman", "oeil-de-la-mort"]),
        .init(id: "flambos", frenchName: "Flambos", creationName: "Jumbo Flambos", threshold: 3, monsterIDs: ["flambos", "flambos-de-foudre", "flambos-de-neige", "flambos-de-glace", "flambos-de-feu", "flambos-noir"]),
        .init(id: "elementaires", frenchName: "Élémentaires", creationName: "Néga Élémentaire", threshold: 3, monsterIDs: ["elementaire-jaune", "elementaire-blanc", "elementaire-rouge", "elementaire-or", "elementaire-bleu", "elementaire-obscur", "elementaire-noir"]),
        .init(id: "carapaces", frenchName: "Carapaces", creationName: "Tankujo", threshold: 3, monsterIDs: ["cujo", "bunyips", "mulfus", "mafut", "shred", "haarma"]),
        .init(id: "dragons", frenchName: "Dragons", creationName: "Fafnir", threshold: 4, monsterIDs: ["vouivre", "lamashtu", "kusarique", "mushussu", "nidhog"]),
        .init(id: "champignons", frenchName: "Champignons", creationName: "Soporichamp", threshold: 5, monsterIDs: ["fungus", "thorn", "exoray"]),
        .init(id: "bombos", frenchName: "Bombos", creationName: "Atomico", threshold: 5, monsterIDs: ["bombo", "grenada", "pyrobolse"]),
        .init(id: "cornus", frenchName: "Cornus", creationName: "Juggernaut", threshold: 5, monsterIDs: ["bicorne", "varaha", "grendel"]),
        .init(id: "geants-de-fer", frenchName: "Géants de fer", creationName: "Titan d’acier", threshold: 10, monsterIDs: ["ekarissor", "gemini-b", "gemini-a"]),
    ]
}

/// Computed values corresponding to the zone, family and overall spreadsheet tables.
struct CaptureSummary: Equatable {
    let captured: Int
    let target: Int
    let completedSpecies: Int
    let missingCaptures: Int
    let missingMonsterIDs: [String]

    init(monsterIDs: [String], counts: [String: Int], threshold: Int = 10) {
        precondition((1...MonsterCatalogue.captureLimit).contains(threshold))
        let values = monsterIDs.map { max(0, min(10, counts[$0, default: 0])) }
        captured = values.reduce(0, +)
        target = monsterIDs.count * threshold
        completedSpecies = values.filter { $0 >= threshold }.count
        missingCaptures = values.reduce(0) { $0 + max(0, threshold - $1) }
        missingMonsterIDs = zip(monsterIDs, values).filter { $0.1 < threshold }.map { $0.0 }
    }
}
