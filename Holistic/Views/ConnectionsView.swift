import SwiftUI

struct ConnectionsView: View {
    @State private var connections: [Connection] = Self.defaultConnections

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text("The capsule captures your body. These connections capture everything outside it.")
                    .font(HTheme.body(13))
                    .foregroundColor(HTheme.dim)
                    .lineSpacing(2)
                    .padding(.bottom, 4)

                // Grouped sections
                ForEach(ConnectionCategory.allCases) { category in
                    let items = connections.filter { $0.category == category }
                    if !items.isEmpty {
                        connectionSection(category: category, items: items)
                    }
                }

                // Data Sovereignty card
                dataSovereigntyCard
                    .padding(.bottom, 100)
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 16)
        }
    }

    // MARK: - Section

    private func connectionSection(category: ConnectionCategory, items: [Connection]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Category header
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(category.color)
                Text(category.rawValue.uppercased())
                    .font(HTheme.label())
                    .foregroundColor(HTheme.dim)
                    .tracking(0.8)
            }
            .padding(.horizontal, HTheme.cardPadding)
            .padding(.top, 10)
            .padding(.bottom, 6)

            // Rows
            VStack(spacing: 0) {
                ForEach(items) { connection in
                    connectionRow(connection: bindingFor(connection))

                    if connection.id != items.last?.id {
                        Divider()
                            .background(HTheme.borderColor)
                    }
                }
            }
        }
        .background(HTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.borderColor, lineWidth: 1)
        )
    }

    // MARK: - Row

    private func connectionRow(connection: Binding<Connection>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(connection.wrappedValue.name)
                    .font(HTheme.body(14, weight: .medium))
                    .foregroundColor(connection.wrappedValue.isEnabled ? HTheme.fg : HTheme.dim)

                Text(connection.wrappedValue.description)
                    .font(HTheme.body(11))
                    .foregroundColor(HTheme.dim.opacity(0.5))
            }

            Spacer()

            Toggle("", isOn: connection.isEnabled)
                .labelsHidden()
                .tint(HTheme.teal)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: connection.wrappedValue.isEnabled)
                .onChange(of: connection.wrappedValue.isEnabled) { _, isOn in
                    HTheme.haptic(isOn ? .light : .rigid)
                }
        }
        .padding(.horizontal, HTheme.cardPadding)
        .padding(.vertical, 12)
    }

    // MARK: - Binding Helper

    private func bindingFor(_ connection: Connection) -> Binding<Connection> {
        guard let index = connections.firstIndex(where: { $0.id == connection.id }) else {
            return .constant(connection)
        }
        return $connections[index]
    }

    // MARK: - Data Sovereignty

    private var dataSovereigntyCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Data Sovereignty")
                .font(HTheme.body(14, weight: .semibold))
                .foregroundColor(HTheme.rust)

            Text("All physiological data processed on-device. External connections transmit only what you authorize. You own every signal your body generates.")
                .font(HTheme.body(12))
                .foregroundColor(HTheme.dim)
                .lineSpacing(2)
        }
        .padding(HTheme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(HTheme.rust.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.rust.opacity(0.07), lineWidth: 1)
        )
    }

    // MARK: - Default Connections (~50)

    static let defaultConnections: [Connection] = [
        // Health & Biometrics
        Connection(name: "Apple Health", description: "Supplementary external sensors", category: .healthBiometrics, isEnabled: true),
        Connection(name: "Oura Ring", description: "Sleep staging and readiness scores", category: .healthBiometrics, isEnabled: true),
        Connection(name: "Continuous Glucose Monitor", description: "Real-time glucose trends", category: .healthBiometrics, isEnabled: true),
        Connection(name: "Whoop Strap", description: "Strain and recovery metrics", category: .healthBiometrics, isEnabled: true),
        Connection(name: "Blood Pressure Cuff", description: "Periodic BP validation", category: .healthBiometrics, isEnabled: false),
        Connection(name: "Genetic Profile · 23andMe", description: "SNP data for personalization", category: .healthBiometrics, isEnabled: true),

        // Smart Home
        Connection(name: "HomeKit", description: "Temperature, humidity, air quality", category: .smartHome, isEnabled: true),
        Connection(name: "Nest Thermostat", description: "Ambient environment optimization", category: .smartHome, isEnabled: true),
        Connection(name: "Dyson Air Purifier", description: "Particulate matter tracking", category: .smartHome, isEnabled: true),
        Connection(name: "Eight Sleep Pod", description: "Bed temperature and sleep environment", category: .smartHome, isEnabled: true),
        Connection(name: "Hue Lighting", description: "Circadian light adjustment", category: .smartHome, isEnabled: true),
        Connection(name: "Ring Doorbell", description: "Arrival and departure patterns", category: .smartHome, isEnabled: false),

        // Transportation
        Connection(name: "Apple CarPlay", description: "Driving stress and commute patterns", category: .transportation, isEnabled: true),
        Connection(name: "Tesla Integration", description: "Cabin environment and drive data", category: .transportation, isEnabled: false),
        Connection(name: "Transit App", description: "Commute duration and movement", category: .transportation, isEnabled: true),
        Connection(name: "Uber / Lyft", description: "Travel frequency and patterns", category: .transportation, isEnabled: false),

        // Work & Productivity
        Connection(name: "Calendar", description: "Schedule for proactive guidance", category: .workProductivity, isEnabled: true),
        Connection(name: "Slack", description: "Communication load and focus interruptions", category: .workProductivity, isEnabled: true),
        Connection(name: "Screen Time", description: "Digital cognitive load tracking", category: .workProductivity, isEnabled: true),
        Connection(name: "Notion", description: "Task completion and cognitive patterns", category: .workProductivity, isEnabled: true),
        Connection(name: "Zoom", description: "Meeting fatigue detection", category: .workProductivity, isEnabled: false),
        Connection(name: "Focus Modes", description: "Automatic mode switching", category: .workProductivity, isEnabled: true),
        Connection(name: "Linear", description: "Sprint velocity and workload balance", category: .workProductivity, isEnabled: false),

        // Finance
        Connection(name: "Financial · Origin", description: "Spending patterns and wellness", category: .finance, isEnabled: true),
        Connection(name: "Mint", description: "Financial stress indicators", category: .finance, isEnabled: false),
        Connection(name: "Robinhood", description: "Investment anxiety correlation", category: .finance, isEnabled: false),
        Connection(name: "Apple Pay", description: "Spending behavior patterns", category: .finance, isEnabled: true),

        // Social
        Connection(name: "Social Contacts", description: "Relationship context mapping", category: .social, isEnabled: false),
        Connection(name: "Messages", description: "Social connection frequency", category: .social, isEnabled: false),
        Connection(name: "Instagram", description: "Social comparison metrics", category: .social, isEnabled: false),
        Connection(name: "Strava Social", description: "Community wellness engagement", category: .social, isEnabled: false),
        Connection(name: "BeReal", description: "Authentic social interaction timing", category: .social, isEnabled: false),

        // Entertainment
        Connection(name: "Apple Music", description: "Emotional state and music correlation", category: .entertainment, isEnabled: true),
        Connection(name: "Spotify", description: "Listening patterns and mood mapping", category: .entertainment, isEnabled: false),
        Connection(name: "Netflix", description: "Evening wind-down patterns", category: .entertainment, isEnabled: true),
        Connection(name: "Apple TV", description: "Passive rest quality metrics", category: .entertainment, isEnabled: false),
        Connection(name: "Podcasts", description: "Intellectual engagement patterns", category: .entertainment, isEnabled: true),

        // Wellness
        Connection(name: "Headspace", description: "Meditation session data", category: .wellness, isEnabled: true),
        Connection(name: "Calm", description: "Breathing exercise history", category: .wellness, isEnabled: false),
        Connection(name: "Peloton", description: "Exercise intensity and recovery", category: .wellness, isEnabled: true),
        Connection(name: "Nike Run Club", description: "Cardiovascular training load", category: .wellness, isEnabled: true),
        Connection(name: "Creative Workspace", description: "iPad Pencil — AI-free zone", category: .wellness, isEnabled: false),
        Connection(name: "Strava", description: "Activity and route data", category: .wellness, isEnabled: true),

        // Education
        Connection(name: "Duolingo", description: "Cognitive exercise patterns", category: .education, isEnabled: false),
        Connection(name: "Kindle", description: "Reading duration and comprehension windows", category: .education, isEnabled: true),
        Connection(name: "Coursera", description: "Learning session optimization", category: .education, isEnabled: false),
        Connection(name: "Anki", description: "Spaced repetition and memory tracking", category: .education, isEnabled: false),

        // Shopping
        Connection(name: "Amazon", description: "Purchase patterns and needs prediction", category: .shopping, isEnabled: false),
        Connection(name: "Instacart", description: "Nutritional choice tracking", category: .shopping, isEnabled: true),
        Connection(name: "Whole Foods", description: "Dietary pattern analysis", category: .shopping, isEnabled: false),

        // Government & ID
        Connection(name: "Location Services", description: "GPS and spatial context", category: .governmentID, isEnabled: true),
        Connection(name: "Apple Wallet ID", description: "Identity verification", category: .governmentID, isEnabled: true),
        Connection(name: "Health Records", description: "Clinical data integration", category: .governmentID, isEnabled: true),
        Connection(name: "Vaccination Records", description: "Immunization status", category: .governmentID, isEnabled: false),
    ]
}
