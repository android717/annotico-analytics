import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .analytics

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    placeholderScreen(title: "Dashboard", icon: "house.fill")
                case .investors:
                    placeholderScreen(title: "Investors", icon: "person.2.fill")
                case .analytics:
                    AnalyticsDashboardView()
                case .settings:
                    placeholderScreen(title: "Settings", icon: "gearshape.fill")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            bottomTabBar
        }
        .ignoresSafeArea(.keyboard)
    }

    private var bottomTabBar: some View {
        HStack {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.snappy(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(selectedTab == tab ? AppColors.gold : .white.opacity(0.35))
                        Text(tab.label)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(selectedTab == tab ? AppColors.gold : .white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.bottom, 16)
        .padding(.top, 6)
        .background(AppColors.navy)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)
        }
    }

    private func placeholderScreen(title: String, icon: String) -> some View {
        VStack(spacing: 0) {
            TopNavBar()
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 48))
                    .foregroundStyle(AppColors.muted.opacity(0.4))
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.navy)
                Text("Coming soon")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColors.muted)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(AppColors.surface)
        }
    }
}

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case investors
    case analytics
    case settings

    var id: String { rawValue }

    var label: String {
        switch self {
        case .home: return "Home"
        case .investors: return "Investors"
        case .analytics: return "Analytics"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .investors: return "person.2.fill"
        case .analytics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
