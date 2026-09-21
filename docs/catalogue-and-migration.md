# Catalogue and saved progress

The catalogue is a reviewed snapshot of the French `Suivi` and `Progression` tables, read on 2026-09-21. It contains 102 monsters, 13 zones and 14 family challenges. It does not include personal capture counts, a spreadsheet identifier, or a live Sheets dependency.

Names and ordering follow the French spreadsheet. The previously audited corrections are applied in code: Couguar and Maître Couguar; Elmidea in Insectes, Galkimasera in Mages volants and Ekarissor in Géants de fer. Creation labels use Fenril, Frelon, Wizarsha, Lieo Nukan, Néga Élémentaire, Soporichamp and Atomico. This PR does not modify the spreadsheet.

The existing English and Italian translations remain accessible through each monster's original localization key. French canonical names are separate from translation keys and persistence IDs.

## Persistence contract

- Catalogue IDs are explicit, frozen identifiers. Never regenerate them from renamed or translated labels. Some intentionally retain historical spellings to keep identity stable.
- Fresh installs start at zero. Existing installs migrate all legacy UserDefaults keys, including Flambos, Emildea, Iguanore, Barracudo Cornu, Gemini A and Gemini B.
- Counts are clamped to 0–10. A single versioned JSON payload stored in UserDefaults contains the migrated save and implicitly marks migration complete.
- The original keys are left untouched. Subsequent launches prefer the modern save, including intentional zero values.
- Corrupt and future-version saves throw an error and remain untouched. The future UI must present a recoverable error rather than silently replacing them.
- Writes persist the proposed counts before updating in-memory state. UserDefaults provides normal local preferences persistence, not a transactional backend or cross-process sync mechanism. Shared widget/Watch storage and backend sync remain later work.

Progress summaries calculate overall totals, zone deficits at one and ten captures, and family deficits at one, the challenge threshold, and ten. Extra captures of one monster never compensate for missing captures of another.

## Verification

Run the XMonsters scheme's tests in Xcode 26 on an iOS 26 simulator. Tests cover catalogue integrity, every legacy key, repeated launch, bounds, corrupt/future saves and family thresholds. This change adds the data layer only; the SwiftUI tracking screens are a separate step.

## References retained from the original application

- FF World Monster Arena guide: http://www.ffworld.com/?rub=ff10&page=q_arene
- Final Fantasy Wiki Monster Arena guide: http://finalfantasy.wikia.com/wiki/Monster_Arena
- French Couguar reference: https://finalfantasy.fandom.com/fr/wiki/Couguar

The legacy DataModel.swift remains excluded from compilation for migration review.
