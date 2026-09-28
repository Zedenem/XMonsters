# Arena reward provenance

The zone and family reward table was checked against:

- French names and family requirements: http://www.ff-heroes.com/final-fantasy-x/quetes/le-centre-dentrainement-des-monstres.html (read 2026-09-28)
- English names: https://jegged.com/Games/Final-Fantasy-X/Monster-Arena/Rewards.html (read 2026-09-22)
- https://jegged.com/Games/Final-Fantasy-X/Monster-Arena/Area-Conquest/Stratoavis.html (Besaid capture condition)

French users see the source's French item and creation names. Other languages currently fall back to the documented English names. The FF Heroes page spells the area creation « Méga Cougar »; the app uses « Méga Couguar » to match the explicitly agreed French spelling. Its list also says the Titan d’acier family requires five of each, so the catalogue's former value of ten was corrected to five. The spreadsheet family threshold should be reconciled separately; this PR leaves the user's spreadsheet unchanged.

Zone unlocks require one of each species in that zone. Family unlock thresholds come from the reviewed catalogue. The ten-of-each collection recap does not claim a separate group reward. Global Original-creature conditions, arena battle victories, reward collection and cumulative unlock rewards are not tracked by these group cards. Completion seals indicate capture requirements met, not a claimed in-game reward.

The Calm Lands card also explains the Nirvana chest and its Celestial Mirror requirement. Gagazet's listed reward is Blossom Crown.

The previous FF World arena URL returned a missing page during the earlier check; the Fandom reference was inaccessible. The working FF Heroes and Jegged links are listed on the dedicated About screen, not in progression details.
