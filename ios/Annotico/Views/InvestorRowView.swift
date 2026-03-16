import SwiftUI

struct InvestorRowView: View {
    let investor: Investor
    let rank: Int
    let filter: FilterType

    var body: some View {
        HStack(spacing: 14) {
            Text("\(rank)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.gold)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.navy)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(investor.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(AppColors.navy)

                HStack(spacing: 10) {
                    Text(investor.project)
                        .font(.system(size: 11.5))
                        .foregroundStyle(AppColors.muted)
                    Text("\(investor.engagementMin) min")
                        .font(.system(size: 11.5))
                        .foregroundStyle(AppColors.muted)
                }

                coviewerLine
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            tagStack

            VStack(alignment: .trailing, spacing: 2) {
                Text(filter.statValue(for: investor))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.navy)
                Text(filter.statLabel)
                    .font(.system(size: 10))
                    .foregroundStyle(AppColors.muted)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    private var coviewerLine: some View {
        Group {
            if investor.coviewers > 0 {
                HStack(spacing: 0) {
                    Text("Co-viewers: ")
                        .foregroundStyle(AppColors.muted)
                    Text("\(investor.coviewerInvites)")
                        .foregroundStyle(AppColors.navy)
                        .fontWeight(.medium)
                    Text(" invite\(investor.coviewerInvites != 1 ? "s" : "") · ")
                        .foregroundStyle(AppColors.muted)
                    Text("\(investor.coviewers)")
                        .foregroundStyle(AppColors.navy)
                        .fontWeight(.medium)
                    Text(" joined")
                        .foregroundStyle(AppColors.muted)
                    if investor.lockMode > 0 {
                        Text(" · ")
                            .foregroundStyle(AppColors.muted)
                        Text("\(investor.lockMode)")
                            .foregroundStyle(AppColors.navy)
                            .fontWeight(.medium)
                        Text(" Lock Mode")
                            .foregroundStyle(AppColors.muted)
                    }
                }
                .font(.system(size: 11))
            } else {
                Text("No co-viewers yet")
                    .font(.system(size: 11))
                    .foregroundStyle(AppColors.muted)
            }
        }
    }

    private var tagStack: some View {
        VStack(spacing: 4) {
            ForEach(Array(investor.tags.prefix(2)), id: \.self) { tag in
                Text(tag.label)
                    .font(.system(size: 10, weight: .semibold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .foregroundStyle(tag.color)
                    .background(tag.bgColor)
                    .clipShape(Capsule())
            }
        }
    }
}
