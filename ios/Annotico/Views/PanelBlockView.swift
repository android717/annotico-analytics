import SwiftUI

struct PanelBlockView: View {
    let isYourInsights: Bool
    let isActive: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: isYourInsights
                                ? [AppColors.navy, AppColors.navy3]
                                : [AppColors.gold, AppColors.gold2],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 5)

                VStack(alignment: .leading, spacing: 6) {
                    Text(isYourInsights ? "YOUR\nINSIGHTS" : "AI\nINSIGHTS")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(AppColors.navy.opacity(0.25))
                        .lineSpacing(2)
                        .padding(.bottom, 4)

                    Text(isYourInsights ? "Your Insights" : "AI Insights")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.navy)

                    Text(isYourInsights
                         ? "Filter and rank investors by engagement data."
                         : "Claude analyses all signals and ranks investors.")
                        .font(.system(size: 11.5))
                        .foregroundStyle(AppColors.muted)
                        .lineSpacing(2)
                        .lineLimit(2)

                    HStack(spacing: 5) {
                        Text(isYourInsights ? "Data-driven" : "AI-powered")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(isYourInsights
                                ? Color(red: 0.93, green: 0.95, blue: 1.0)
                                : Color(red: 0.788, green: 0.659, blue: 0.298).opacity(0.12))
                    .foregroundStyle(isYourInsights
                                    ? AppColors.navy
                                    : Color(red: 0.541, green: 0.416, blue: 0.102))
                    .clipShape(Capsule())
                    .padding(.top, 6)
                }
                .padding(16)
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isActive ? AppColors.gold : AppColors.border, lineWidth: isActive ? 2 : 1.5)
            }
            .shadow(color: isActive ? AppColors.gold.opacity(0.12) : .black.opacity(0.06), radius: isActive ? 12 : 8, y: isActive ? 4 : 2)
        }
        .buttonStyle(.plain)
    }
}
