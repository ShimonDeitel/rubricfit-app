import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    @State private var draftName: String = ""
    @State private var draftDone: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.primary)
                            if !((item.done ? "done" : "not done").isEmpty) {
                                Text((item.done ? "done" : "not done"))
                                    .font(Theme.captionFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Rubricfit")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $draftName)
                    .accessibilityIdentifier("field_name")
                Toggle("Done", isOn: $draftDone)
            }
            .navigationTitle("Add Criterion")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Criterion(name: draftName, done: draftDone)
                        store.add(item)
                        resetDraft()
                        showingAdd = false
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func resetDraft() {
        draftName = ""
        draftDone = false
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
