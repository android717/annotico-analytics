import SwiftUI

nonisolated struct Investor: Identifiable, Hashable {
    let id: String
    let name: String
    let email: String
    let project: String
    let revisits: Int
    let engagementMin: Int
    let totalTime: String
    let coviewers: Int
    let coviewerInvites: Int
    let lockMode: Int
    let enquiries: Int
    let hasPayment: Bool
    let hasVideo: Bool
    let hasImage: Bool
    let hasCollab: Bool
    let videoMin: Int
    let imageMin: Int
    let paymentViews: Int
    let aiScore: Int
    let badge: InvestorBadge
    let rank: Int

    var overallScore: Int {
        let revisitScore = min(revisits, 10) * 8
        let engageScore = Int(Double(min(engagementMin, 60)) * 0.8)
        let coviewScore = min(coviewers, 5) * 10
        let paymentScore = min(paymentViews, 5) * 6
        let videoScore = Int(Double(min(videoMin, 30)) * 0.5)
        let imageScore = Int(Double(min(imageMin, 20)) * 0.3)
        let lockScore = min(lockMode, 3) * 4
        let total = revisitScore + engageScore + coviewScore + paymentScore + videoScore + imageScore + lockScore
        return min(total, 100)
    }

    var tags: [InvestorTag] {
        var result: [InvestorTag] = []
        if revisits > 0 { result.append(.revisit(revisits)) }
        if hasCollab { result.append(.collab) }
        return result
    }
}

nonisolated enum InvestorBadge: String, Hashable {
    case callNow = "Call Now"
    case followUp = "Follow Up"
    case watch = "Watch"

    var color: Color {
        switch self {
        case .callNow: return AppColors.green
        case .followUp: return AppColors.amber
        case .watch: return AppColors.red
        }
    }

    var softColor: Color {
        switch self {
        case .callNow: return AppColors.greenSoft
        case .followUp: return AppColors.amberSoft
        case .watch: return AppColors.redSoft
        }
    }
}

nonisolated enum InvestorTag: Hashable {
    case revisit(Int)
    case collab

    var label: String {
        switch self {
        case .revisit(let count): return "\(count) Revisit\(count > 1 ? "s" : "")"
        case .collab: return "Co-viewed"
        }
    }

    var color: Color {
        switch self {
        case .revisit: return Color(red: 0.23, green: 0.31, blue: 0.66)
        case .collab: return Color(red: 0.09, green: 0.40, blue: 0.20)
        }
    }

    var bgColor: Color {
        switch self {
        case .revisit: return Color(red: 0.93, green: 0.95, blue: 1.0)
        case .collab: return Color(red: 0.94, green: 0.99, blue: 0.96)
        }
    }
}

nonisolated enum FilterType: String, CaseIterable, Identifiable {
    case revisits = "Revisits"
    case engagement = "Engagement"
    case collab = "Collaborative"

    var id: String { rawValue }

    var sectionLabel: String {
        switch self {
        case .revisits: return "Top 10 — By Revisits"
        case .engagement: return "Top 10 — By Engagement Time"
        case .collab: return "Top 10 — Collaborative Sessions"
        }
    }

    var statLabel: String {
        switch self {
        case .revisits: return "revisits"
        case .engagement: return "total time"
        case .collab: return "co-viewers"
        }
    }

    func statValue(for investor: Investor) -> String {
        switch self {
        case .revisits: return "\(investor.revisits)"
        case .engagement: return "\(investor.engagementMin)m"
        case .collab: return investor.coviewers > 0 ? "\(investor.coviewers)" : "—"
        }
    }

    func sortedInvestors(_ investors: [Investor]) -> [Investor] {
        switch self {
        case .revisits: return investors.sorted { $0.revisits > $1.revisits }
        case .engagement: return investors.sorted { $0.engagementMin > $1.engagementMin }
        case .collab: return investors.sorted { $0.coviewers > $1.coviewers }
        }
    }
}

nonisolated enum AIInsightGroup: String, CaseIterable {
    case callNow = "Call Now"
    case followUp = "Follow Up"
    case watch = "Watch"

    var color: Color {
        switch self {
        case .callNow: return AppColors.green
        case .followUp: return AppColors.amber
        case .watch: return AppColors.red
        }
    }

    var lightColor: Color {
        switch self {
        case .callNow: return Color(red: 0.50, green: 0.88, blue: 0.74)
        case .followUp: return Color(red: 1.0, green: 0.72, blue: 0.42)
        case .watch: return Color(red: 1.0, green: 0.50, blue: 0.50)
        }
    }
}

nonisolated struct AIInsight: Identifiable, Hashable {
    let id: String
    let investorId: String
    let name: String
    let email: String
    let rank: Int
    let score: Int
    let group: AIInsightGroup
    let reasoning: String
    let suggestedMessage: String?
}

nonisolated enum DetailTab: String, CaseIterable, Identifiable {
    case engagement = "Engagement"
    case timeline = "Timeline"
    case coviewers = "Co-viewers"
    case enquiries = "Enquiries"
    case aiInsights = "AI Insights"

    var id: String { rawValue }
}
