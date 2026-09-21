import SwiftUI

private func ui(_ key: String) -> String {
    NSLocalizedString(key, tableName: "Tracker", bundle: .main, comment: "")
}

struct RootView: View {
    @State private var progress: CaptureProgress?
    @State private var loadFailed = false

    var body: some View {
        Group {
            if let progress {
                TabView {
                    NavigationStack { CaptureList(progress: progress) }
                        .tabItem { Label(ui("Captures"), systemImage: "checklist") }
                    NavigationStack { ProgressionView(progress: progress) }
                        .tabItem { Label(ui("Progression"), systemImage: "chart.bar.fill") }
                    NavigationStack { AboutView() }
                        .tabItem { Label(ui("About"), systemImage: "info.circle") }
                }
            } else if loadFailed {
                ContentUnavailableView {
                    Label(ui("Progress could not be opened"), systemImage: "exclamationmark.triangle")
                } description: {
                    Text(ui("Your saved data has been kept. Check for an app update, then try again."))
                } actions: {
                    Button(ui("Try again"), action: load)
                }
            } else {
                ProgressView()
            }
        }
        .task { if progress == nil { load() } }
    }

    private func load() {
        do {
            progress = try CaptureProgress()
            loadFailed = false
        } catch { loadFailed = true }
    }
}

enum CaptureSearch {
    static func matches(_ query: String, names: [String]) -> Bool {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return query.isEmpty || names.contains {
            $0.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
    }
}

private extension CaptureZone {
    var localizedName: String {
        if Bundle.main.preferredLocalizations.first?.hasPrefix("fr") == true { return frenchName }
        return Bundle.main.localizedString(forKey: localizationKey, value: frenchName, table: nil)
    }
}

private struct CaptureList: View {
    let progress: CaptureProgress
    @State private var query = ""
    @State private var incompleteOnly = false

    private func monsters(in zone: CaptureZone) -> [CaptureMonster] {
        MonsterCatalogue.monsters.filter {
            $0.zoneID == zone.id
                && (!incompleteOnly || progress.count(for: $0.id) < 10)
                && CaptureSearch.matches(query, names: [$0.frenchName, $0.localizedName()])
        }
    }

    var body: some View {
        List {
            Section {
                SummaryRow(summary: progress.overall)
                Toggle(ui("Incomplete only"), isOn: $incompleteOnly)
            }
            ForEach(MonsterCatalogue.zones) { zone in
                let visible = monsters(in: zone)
                if !visible.isEmpty {
                    Section(zone.localizedName) {
                        ForEach(visible) { CaptureRow(monster: $0, progress: progress) }
                    }
                }
            }
            if MonsterCatalogue.zones.allSatisfy({ monsters(in: $0).isEmpty }) {
                ContentUnavailableView(ui("No matching monsters"), systemImage: "magnifyingglass",
                                       description: Text(ui("Change your search or show completed monsters.")))
            }
        }
        .navigationTitle(ui("Captures"))
        .searchable(text: $query, prompt: ui("Find a monster"))
    }
}

private struct CaptureRow: View {
    let monster: CaptureMonster
    let progress: CaptureProgress
    @State private var saveFailed = false

    var body: some View {
        Stepper(value: Binding(
            get: { progress.count(for: monster.id) },
            set: { value in
                do { try progress.setCount(value, for: monster.id) }
                catch { saveFailed = true }
            }
        ), in: 0...10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(monster.localizedName())
                HStack {
                    Text("\(progress.count(for: monster.id)) / 10").monospacedDigit()
                    if progress.count(for: monster.id) == 10 {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .accessibilityLabel(ui("Complete"))
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .accessibilityLabel(monster.localizedName())
        .accessibilityValue("\(progress.count(for: monster.id)) / 10")
        .alert(ui("Could not save"), isPresented: $saveFailed) {
            Button(ui("OK"), role: .cancel) { }
        } message: {
            Text(ui("The change was not applied. Try again."))
        }
    }
}

private struct SummaryRow: View {
    let summary: CaptureSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(format: ui("%d captures remaining"), summary.missingCaptures))
                .font(.headline)
            ProgressView(value: Double(summary.target - summary.missingCaptures),
                         total: Double(max(1, summary.target)))
                .accessibilityLabel(ui("Progression"))
            Text(String(format: ui("%d of %d species complete"), summary.completedSpecies,
                        summary.completedSpecies + summary.missingMonsterIDs.count))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct ProgressionView: View {
    let progress: CaptureProgress

    var body: some View {
        List {
            Section(ui("Overall")) { SummaryRow(summary: progress.overall) }
            Section(ui("Zones")) {
                ForEach(MonsterCatalogue.zones) { zone in
                    NavigationLink {
                        ProgressGroupView(title: zone.localizedName,
                                          monsterIDs: MonsterCatalogue.monsters.filter { $0.zoneID == zone.id }.map(\.id),
                                          challenge: nil, progress: progress)
                    } label: {
                        groupLabel(zone.localizedName, summary: progress.summary(for: zone))
                    }
                }
            }
            Section(ui("Family challenges")) {
                ForEach(MonsterCatalogue.families) { family in
                    NavigationLink {
                        ProgressGroupView(title: family.frenchName + " — " + family.creationName,
                                          monsterIDs: family.monsterIDs, challenge: family.threshold,
                                          progress: progress)
                    } label: {
                        groupLabel(family.frenchName + " — " + family.creationName,
                                   summary: progress.summary(for: family))
                    }
                }
            }
        }
        .navigationTitle(ui("Progression"))
    }

    private func groupLabel(_ name: String, summary: CaptureSummary) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
            Text(String(format: ui("%d captures remaining"), summary.missingCaptures))
                .font(.caption).foregroundStyle(.secondary)
        }
    }
}

private struct ProgressGroupView: View {
    let title: String
    let monsterIDs: [String]
    let challenge: Int?
    let progress: CaptureProgress
    @State private var threshold: Int

    init(title: String, monsterIDs: [String], challenge: Int?, progress: CaptureProgress) {
        self.title = title
        self.monsterIDs = monsterIDs
        self.challenge = challenge
        self.progress = progress
        _threshold = State(initialValue: challenge ?? 1)
    }

    private var summary: CaptureSummary {
        CaptureSummary(monsterIDs: monsterIDs, counts: progress.counts, threshold: threshold)
    }

    var body: some View {
        List {
            Section {
                Picker(ui("Goal"), selection: $threshold) {
                    Text(ui("One each")).tag(1)
                    if let challenge, challenge != 10 {
                        Text(String(format: ui("Challenge (%d)"), challenge)).tag(challenge)
                    }
                    Text(ui("Ten each")).tag(10)
                }
                SummaryRow(summary: summary)
            }
            Section(ui("Missing monsters")) {
                if summary.missingMonsterIDs.isEmpty {
                    Label(ui("Goal complete"), systemImage: "checkmark.circle")
                }
                ForEach(monsterIDs, id: \.self) { id in
                    if summary.missingMonsterIDs.contains(id),
                       let monster = MonsterCatalogue.monsters.first(where: { $0.id == id }) {
                        CaptureRow(monster: monster, progress: progress)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AboutView: View {
    var body: some View {
        List {
            Section {
                Text("XMonsters").font(.title.bold())
                Text(ui("A Final Fantasy X capture companion by Zedenem."))
                Link(ui("Source code"), destination: URL(string: "https://github.com/Zedenem/XMonsters")!)
                Link("@zedenem · X", destination: URL(string: "https://x.com/zedenem")!)
                Text(ui("Donations — link coming soon")).foregroundStyle(.secondary)
            }
            Section(ui("Sources")) {
                Link("FF World", destination: URL(string: "http://www.ffworld.com/?rub=ff10&page=q_arene")!)
                Link("Final Fantasy Wiki", destination: URL(string: "https://finalfantasy.fandom.com/wiki/Monster_Arena")!)
            }
            Section(ui("Sync")) {
                Text(ui("Progress is saved on this device. Optional account sync is planned for v2."))
            }
        }
        .navigationTitle(ui("About"))
    }
}
