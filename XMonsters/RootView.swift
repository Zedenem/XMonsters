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
                    Section {
                        ForEach(visible) { CaptureRow(monster: $0, progress: progress) }
                    } header: {
                        let summary = progress.summary(for: zone)
                        HStack {
                            Text(zone.localizedName)
                            Spacer()
                            Text("\(summary.completedSpecies)/\(summary.completedSpecies + summary.missingMonsterIDs.count)")
                                .monospacedDigit()
                                .accessibilityLabel(String(format: ui("%d of %d species complete"),
                                    summary.completedSpecies, summary.completedSpecies + summary.missingMonsterIDs.count))
                        }
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

enum CaptureVisualState: Equatable {
    case uncaught, inProgress, complete

    init(count: Int) {
        self = count <= 0 ? .uncaught : (count >= 10 ? .complete : .inProgress)
    }

    var symbol: String {
        switch self {
        case .uncaught: "circle.dashed"
        case .inProgress: "circle.lefthalf.filled"
        case .complete: "checkmark.circle.fill"
        }
    }

    var title: String {
        switch self {
        case .uncaught: ui("Not caught")
        case .inProgress: ui("In progress")
        case .complete: ui("Complete")
        }
    }

    var color: Color {
        switch self {
        case .uncaught: .secondary
        case .inProgress: .orange
        case .complete: .green
        }
    }
}

extension CaptureMonster {
    var captureFamily: CaptureFamily? {
        MonsterCatalogue.families.first { $0.monsterIDs.contains(id) }
    }

    func familyGoalReached(count: Int) -> Bool {
        guard let family = captureFamily else { return false }
        return count >= family.threshold
    }
}

private struct CaptureRow: View {
    let monster: CaptureMonster
    let progress: CaptureProgress
    @State private var saveFailed = false

    private var count: Int { progress.count(for: monster.id) }
    private var state: CaptureVisualState { CaptureVisualState(count: count) }

    var body: some View {
        Stepper(value: Binding(
            get: { count },
            set: { value in
                do { try progress.setCount(value, for: monster.id) }
                catch { saveFailed = true }
            }
        ), in: 0...10) {
            VStack(alignment: .leading, spacing: 6) {
                Text(monster.localizedName()).fontWeight(count == 10 ? .semibold : .regular)
                Label("\(count) / 10 · \(state.title)", systemImage: state.symbol)
                    .font(.caption).monospacedDigit().foregroundStyle(state.color)
                ProgressView(value: Double(count), total: 10)
                    .tint(state.color)
                    .accessibilityHidden(true)
                if let family = monster.captureFamily {
                    let reached = monster.familyGoalReached(count: count)
                    Label(String(format: ui(reached ? "Family goal reached (%d)" : "Family goal pending (%d)"),
                                 family.threshold),
                          systemImage: reached ? "medal.fill" : "medal")
                        .font(.caption2)
                        .foregroundStyle(reached ? Color.purple : Color.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .listRowBackground(state.color.opacity(0.08))
        .accessibilityLabel(monster.localizedName())
        .accessibilityValue("\(count) / 10 · \(state.title)")
        .accessibilityHint(monster.captureFamily.map {
            String(format: ui(monster.familyGoalReached(count: count)
                ? "Family goal reached (%d)" : "Family goal pending (%d)"), $0.threshold)
        } ?? "")
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
                                          challenge: nil, reward: ArenaRewards.zones[zone.id], progress: progress)
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
                                          reward: ArenaRewards.families[family.id], progress: progress)
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
    let reward: ArenaReward?
    let progress: CaptureProgress

    var body: some View {
        List {
            Section(ui("Goals and rewards")) {
                goal(threshold: challenge ?? 1, reward: reward)
                if challenge != 10 {
                    goal(threshold: 10, reward: nil)
                }
                Text(ui("Capture requirements only; collect rewards from the arena owner."))
                    .font(.caption).foregroundStyle(.secondary)
                if reward != nil {
                    Link(ui("Reward source (English)"), destination: ArenaRewards.source)
                }
            }
            Section(ui("All monsters")) {
                ForEach(monsterIDs, id: \.self) { id in
                    if let monster = MonsterCatalogue.monsters.first(where: { $0.id == id }) {
                        CaptureRow(monster: monster, progress: progress)
                    }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func goal(threshold: Int, reward: ArenaReward?) -> some View {
        let summary = CaptureSummary(monsterIDs: monsterIDs, counts: progress.counts, threshold: threshold)
        return VStack(alignment: .leading, spacing: 8) {
            Label(String(format: ui("Capture %d of each monster"), threshold),
                  systemImage: summary.missingCaptures == 0 ? "checkmark.seal.fill" : "seal")
                .font(.headline)
            Text(String(format: ui("%d captures remaining"), summary.missingCaptures))
                .font(.subheadline).foregroundStyle(.secondary)
            if let reward {
                Text(ui("Reward (English name):") + " " + reward.item)
                Text(ui("Arena unlock (English name):") + " " + reward.unlock)
                if let note = reward.note { Text(ui(note)).font(.caption) }
            } else {
                Text(ui("Collection goal. No separate reward for completing ten in this group alone."))
                    .font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
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
