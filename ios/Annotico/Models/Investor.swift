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
        if hasPayment { result.append(.payment) }
        if hasCollab { result.append(.collab) }
        if hasVideo { result.append(.video) }
        if hasImage { result.append(.image) }
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
    case payment
    case video
    case image

    var label: String {
        switch self {
        case .revisit(let count): return "\(count) Revisit\(count > 1 ? "s" : "")"
        case .collab: return "Co-viewed"
        case .payment: return "Payment Plan"
        case .video: return "Video"
        case .image: return "Images"
        }
    }

    var color: Color {
        switch self {
        case .revisit: return Color(red: 0.23, green: 0.31, blue: 0.66)
        case .collab: return Color(red: 0.09, green: 0.40, blue: 0.20)
        case .payment: return Color(red: 0.57, green: 0.25, blue: 0.05)
        case .video: return Color(red: 0.53, green: 0.10, blue: 0.56)
        case .image: return Color(red: 0.03, green: 0.35, blue: 0.52)
        }
    }

    var bgColor: Color {
        switch self {
        case .revisit: return Color(red: 0.93, green: 0.95, blue: 1.0)
        case .collab: return Color(red: 0.94, green: 0.99, blue: 0.96)
        case .payment: return Color(red: 1.0, green: 0.98, blue: 0.93)
        case .video: return Color(red: 0.99, green: 0.95, blue: 0.97)
        case .image: return Color(red: 0.94, green: 0.98, blue: 1.0)
        }
    }
}

nonisolated enum FilterType: String, CaseIterable, Identifiable {
    case overall = "Overall Score"
    case revisits = "Revisits"
    case engagement = "Engagement"
    case collab = "Collaborative"
    case payment = "Payment Plan"
    case video = "Videos"
    case image = "Images"

    var id: String { rawValue }

    var sectionLabel: String {
        switch self {
        case .overall: return "Overall Top 10 — All Parameters"
        case .revisits: return "Top 10 — By Revisits"
        case .engagement: return "Top 10 — By Engagement Time"
        case .collab: return "Top 10 — Collaborative Sessions"
        case .payment: return "Top 10 — Viewed Payment Plan"
        case .video: return "Top 10 — Viewed Videos"
        case .image: return "Top 10 — Viewed Images"
        }
    }

    var statLabel: String {
        switch self {
        case .overall: return "overall score"
        case .revisits: return "revisits"
        case .engagement: return "total time"
        case .collab: return "co-viewers"
        case .payment: return "views"
        case .video: return "video time"
        case .image: return "image time"
        }
    }

    func statValue(for investor: Investor) -> String {
        switch self {
        case .overall: return "\(investor.overallScore)"
        case .revisits: return "\(investor.revisits)"
        case .engagement: return "\(investor.engagementMin)m"
        case .collab: return investor.coviewers > 0 ? "\(investor.coviewers)" : "—"
        case .payment: return investor.paymentViews > 0 ? "\(investor.paymentViews)x" : "—"
        case .video: return investor.videoMin > 0 ? "\(investor.videoMin)m" : "—"
        case .image: return investor.imageMin > 0 ? "\(investor.imageMin)m" : "—"
        }
    }

    func sortedInvestors(_ investors: [Investor]) -> [Investor] {
        switch self {
        case .overall: return investors.sorted { $0.overallScore > $1.overallScore }
        case .revisits: return investors.sorted { $0.revisits > $1.revisits }
        case .engagement: return investors.sorted { $0.engagementMin > $1.engagementMin }
        case .collab: return investors.sorted { $0.coviewers > $1.coviewers }
        case .payment: return investors.sorted { $0.paymentViews > $1.paymentViews }
        case .video: return investors.sorted { $0.videoMin > $1.videoMin }
        case .image: return investors.sorted { $0.imageMin > $1.imageMin }
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
