# Agreed release scope

Every implementation step is reviewed in a pull request and requires approval before merge and proceeding to the next step.

## v1 — iOS 26+

- SwiftUI tracker with French canonical monster names and preserved existing translations.
- Spreadsheet-derived capture, zone, family and overall progression tables.
- Monster details with names and pictures; weaknesses/descriptions when suitable sources are available.
- Preserve source credits, @zedenem via an X link, and a donation placeholder until a URL is supplied.
- Firebase Crashlytics and analytics (Google Analytics for Firebase preferred; compare alternatives before implementation). No sign-in requirement for these integrations.

## v1.1

- Quick-tracking widget and Apple Watch companion.

## v2

- Optional backend sync using Firebase or Supabase, selected by cost at implementation time. Optional authentication entered through About; local-only remains the default. No progress import/export feature.
- Banner and interstitial ads, plus an ad-free subscription.
- Admin entitlement suppressing all ads and subscription prompts, securely assigned through the backend. Development override for testing only.

These integrations require separate reviewed implementation steps; the data-layer PR does not activate them.
