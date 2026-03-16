import SwiftUI

struct AnalyticsDashboardView: View {
    @State private var viewModel = AnalyticsViewModel()
    @State private var selectedInvestor: Investor?
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopNavBar()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        pageHeader
                        blocksGrid
                        disclaimer

                        if viewModel.selectedPanel == .yourInsights {
                            yourInsightsPanel
                        } else {
                            aiInsightsPanel
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
                .background(AppColors.surface)
                .scrollIndicators(.hidden)
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Investor.self) { investor in
                InvestorDetailView(investor: investor)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5)) {
                    appeared = true
                }
            }
        }
    }

    private var pageHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Analytics")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundStyle(AppColors.navy)
            Text("Investor engagement intelligence — updated daily")
                .font(.system(size: 13))
                .foregroundStyle(AppColors.muted)
        }
    }

    private var blocksGrid: some View {
        HStack(spacing: 12) {
            PanelBlockView(
                isYourInsights: true,
                isActive: viewModel.selectedPanel == .yourInsights
            ) {
                withAnimation(.snappy(duration: 0.3)) {
                    viewModel.selectedPanel = .yourInsights
                }
            }

            PanelBlockView(
                isYourInsights: false,
                isActive: viewModel.selectedPanel == .aiInsights
            ) {
                withAnimation(.snappy(duration: 0.3)) {
                    viewModel.selectedPanel = .aiInsights
                }
            }
        }
    }

    private var disclaimer: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 12))
                .foregroundStyle(Color(red: 0.478, green: 0.376, blue: 0.125))
            Text("Annotico analyses engagement signals to help you prioritise. All decisions remain yours. Annotico is not responsible for outcomes based on these insights.")
                .font(.system(size: 11.5))
                .foregroundStyle(Color(red: 0.478, green: 0.376, blue: 0.125))
                .italic()
                .lineSpacing(2)
        }
        .padding(12)
        .background(Color(red: 1.0, green: 0.992, blue: 0.941))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(Color(red: 0.941, green: 0.851, blue: 0.541))
                .frame(width: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var yourInsightsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            FilterTabsView(selected: Binding(
                get: { viewModel.selectedFilter },
                set: { newValue in
                    withAnimation(.snappy(duration: 0.25)) {
                        viewModel.selectedFilter = newValue
                    }
                }
            ))

            Text(viewModel.selectedFilter.sectionLabel.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(AppColors.muted)
                .tracking(1.5)

            LazyVStack(spacing: 10) {
                ForEach(Array(viewModel.filteredInvestors.enumerated()), id: \.element.id) { index, investor in
                    NavigationLink(value: investor) {
                        InvestorRowView(
                            investor: investor,
                            rank: index + 1,
                            filter: viewModel.selectedFilter
                        )
                    }
                    .buttonStyle(.plain)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 15)
                    .animation(.spring(response: 0.4).delay(Double(index) * 0.05), value: appeared)
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .leading)))
    }

    private var aiInsightsPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("AI RANKED · TODAY 8:00 AM")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppColors.muted)
                    .tracking(1.5)
                Spacer()
                Button {
                    viewModel.refreshAI()
                } label: {
                    HStack(spacing: 6) {
                        if viewModel.isRefreshingAI {
                            ProgressView()
                                .scaleEffect(0.7)
                                .tint(Color(red: 0.541, green: 0.416, blue: 0.102))
                        }
                        Text(viewModel.isRefreshingAI ? "Generating..." : "Refresh")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .foregroundStyle(Color(red: 0.541, green: 0.416, blue: 0.102))
                    .background(Color(red: 0.788, green: 0.659, blue: 0.298).opacity(0.12))
                    .clipShape(Capsule())
                    .overlay {
                        Capsule()
                            .strokeBorder(Color(red: 0.788, green: 0.659, blue: 0.298).opacity(0.3), lineWidth: 1)
                    }
                }
                .disabled(viewModel.isRefreshingAI)
            }

            ForEach(AIInsightGroup.allCases, id: \.self) { group in
                if let insights = viewModel.aiInsights[group], !insights.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(group.rawValue.uppercased())
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(group.color)
                            .tracking(1.5)
                            .padding(.bottom, 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(alignment: .bottom) {
                                Rectangle()
                                    .fill(AppColors.border)
                                    .frame(height: 1)
                            }

                        ForEach(insights) { insight in
                            AIInsightCardView(
                                insight: insight,
                                viewModel: viewModel
                            ) {
                                if let investor = viewModel.investorById(insight.investorId) {
                                    selectedInvestor = investor
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                }
            }
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }
}
