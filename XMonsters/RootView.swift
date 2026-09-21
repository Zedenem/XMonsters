import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image("X")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 112)
                    .accessibilityHidden(true)

                VStack(spacing: 8) {
                    Text(AppIdentity.name)
                        .font(.largeTitle.bold())

                    Text("The iOS 26 foundation is ready.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .navigationTitle(AppIdentity.name)
        }
    }
}

#Preview {
    RootView()
}
