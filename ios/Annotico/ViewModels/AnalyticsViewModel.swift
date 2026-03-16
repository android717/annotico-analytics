import SwiftUI

@Observable
@MainActor
class AnalyticsViewModel {
    var selectedPanel: PanelType = .yourInsights
    var selectedFilter: FilterType = .overall
    var selectedDetailTab: DetailTab = .engagement
    var isRefreshingAI: Bool = false
    var copiedMessageId: String?
    var editingMessageId: String?
    var editedMessages: [String: String] = [:]

    enum PanelType: String {
        case yourInsights
        case aiInsights
    }

    var filteredInvestors: [Investor] {
        selectedFilter.sortedInvestors(SampleData.investors)
    }

    var aiInsights: [AIInsightGroup: [AIInsight]] {
        Dictionary(grouping: SampleData.aiInsights, by: \.group)
    }

    func refreshAI() {
        guard !isRefreshingAI else { return }
        isRefreshingAI = true
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            isRefreshingAI = false
        }
    }

    func copyMessage(id: String, text: String) {
        UIPasteboard.general.string = text
        copiedMessageId = id
        Task {
            try? await Task.sleep(for: .seconds(2))
            if copiedMessageId == id {
                copiedMessageId = nil
            }
        }
    }

    func investorById(_ id: String) -> Investor? {
        SampleData.investors.first { $0.id == id }
    }
}

enum SampleData {
    static let investors: [Investor] = [
        Investor(id: "ahmed", name: "Ahmed Al Mansouri", email: "ahmed@gmail.com", project: "Parkland V2",
                 revisits: 5, engagementMin: 31, totalTime: "47m", coviewers: 1, coviewerInvites: 3, lockMode: 1, enquiries: 2,
                 hasPayment: true, hasVideo: true, hasImage: true, hasCollab: true,
                 videoMin: 18, imageMin: 8, paymentViews: 3, aiScore: 87, badge: .callNow, rank: 1),
        Investor(id: "priya", name: "Priya Sharma", email: "priya@yahoo.com", project: "Marina Heights",
                 revisits: 4, engagementMin: 47, totalTime: "31m", coviewers: 1, coviewerInvites: 1, lockMode: 0, enquiries: 0,
                 hasPayment: false, hasVideo: true, hasImage: false, hasCollab: true,
                 videoMin: 24, imageMin: 0, paymentViews: 0, aiScore: 58, badge: .followUp, rank: 3),
        Investor(id: "khalid", name: "Khalid Al Rashid", email: "khalid@hotmail.com", project: "Emaar Beachfront",
                 revisits: 3, engagementMin: 22, totalTime: "22m", coviewers: 0, coviewerInvites: 0, lockMode: 0, enquiries: 0,
                 hasPayment: false, hasVideo: false, hasImage: true, hasCollab: false,
                 videoMin: 0, imageMin: 19, paymentViews: 0, aiScore: 34, badge: .watch, rank: 4),
        Investor(id: "sunita", name: "Sunita Kapoor", email: "sunita@outlook.com", project: "Sobha Hartland",
                 revisits: 2, engagementMin: 18, totalTime: "18m", coviewers: 3, coviewerInvites: 3, lockMode: 2, enquiries: 1,
                 hasPayment: true, hasVideo: false, hasImage: false, hasCollab: true,
                 videoMin: 0, imageMin: 0, paymentViews: 5, aiScore: 74, badge: .callNow, rank: 2),
        Investor(id: "omar", name: "Omar Farooq", email: "omar@gmail.com", project: "Creek Harbour",
                 revisits: 1, engagementMin: 9, totalTime: "9m", coviewers: 0, coviewerInvites: 0, lockMode: 0, enquiries: 0,
                 hasPayment: false, hasVideo: false, hasImage: false, hasCollab: false,
                 videoMin: 0, imageMin: 0, paymentViews: 0, aiScore: 18, badge: .watch, rank: 5),
    ]

    static let aiInsights: [AIInsight] = [
        AIInsight(id: "ai1", investorId: "ahmed", name: "Ahmed Al Mansouri", email: "ahmed@gmail.com",
                  rank: 1, score: 87, group: .callNow,
                  reasoning: "5 revisits, payment plan engaged, 2 co-viewers with Lock Mode — strong buying consideration with circle involvement.",
                  suggestedMessage: "Hi, just checking in — have you had a chance to think it over? Happy to answer any questions whenever you're ready."),
        AIInsight(id: "ai2", investorId: "sunita", name: "Sunita Kapoor", email: "sunita@outlook.com",
                  rank: 2, score: 74, group: .callNow,
                  reasoning: "Payment plan viewed, both co-viewers used Lock Mode — multiple decision makers in serious review.",
                  suggestedMessage: "Hi, just checking in — have you had a chance to think it over? Happy to answer any questions whenever you're ready."),
        AIInsight(id: "ai3", investorId: "priya", name: "Priya Sharma", email: "priya@yahoo.com",
                  rank: 3, score: 58, group: .followUp,
                  reasoning: "4 revisits, video viewed — sustained interest but no payment plan engagement yet.",
                  suggestedMessage: "Hi, just checking in — have you had a chance to think it over? Happy to answer any questions whenever you're ready."),
        AIInsight(id: "ai4", investorId: "khalid", name: "Khalid Al Rashid", email: "khalid@hotmail.com",
                  rank: 4, score: 34, group: .watch,
                  reasoning: "3 revisits but images only, no payment plan, no co-viewers — casual browsing pattern.",
                  suggestedMessage: nil),
        AIInsight(id: "ai5", investorId: "omar", name: "Omar Farooq", email: "omar@gmail.com",
                  rank: 5, score: 18, group: .watch,
                  reasoning: "Single revisit, 9 minutes, no interactions — minimal engagement signals.",
                  suggestedMessage: nil),
    ]
}
