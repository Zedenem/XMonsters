# Tracking screen verification

Run the XMonsters scheme tests and launch the app on an iOS 26 simulator using Xcode 26. Compilation, tests, accessibility and layout must be verified on macOS; they have not been run in the Linux authoring environment.

1. Start with a fresh app installation: all 102 counts are zero and 1,020 captures remain.
2. Increment Dingo, switch to Progression, and check that overall and Besaid deficits decrease immediately. Relaunch and confirm the count persists.
3. Check that decrement stops at zero and increment stops at ten. Check gray/dashed-circle/Not caught at zero, orange/half-circle/In progress at 1–9, and green/checkmark/Complete at ten in every list. At ten, the row disappears only when Captures' Incomplete only is selected. Turn that filter off to adjust a completed count. Check that Besaid's header changes from 0/3 to 1/3 only at ten and is unaffected by search filtering.
4. Search in French and the active translated language. Check an accent-insensitive query such as `elementaire` and an unmatched query. Clear search to restore the list.
5. Open a zone or family: there must be no goal picker and every monster must remain visible at zero, at its challenge threshold and at ten. Check fixed goal recaps with deficits, reward and arena unlock, plus the separate collection goal. Family threshold ten must not produce a duplicate goal. Confirm an individual monster's medal fills at its family threshold and un-fills when decremented below it; this does not imply the whole family is complete. Monsters without a family have no medal.
6. On a test installation with a legacy save, verify the irregular keys listed in catalogue-and-migration.md migrate. On a test installation with corrupt or future-version modern data, verify the recovery screen appears and does not erase the stored data.
7. Test French, English and Italian, large Dynamic Type, VoiceOver, dark mode, iPhone and iPad. Existing monster translations remain in use; family and creation names remain canonical French until translated data is supplied.
8. Check About's source credits, repository and X links. The donation entry is noninteractive until a URL is provided. Sync is informational only; no authentication is required.

The tracker loads its local save once at launch. Cross-process changes, widget/Watch storage, cloud sync, telemetry and monetization are later roadmap steps. No destructive reset action is exposed.
