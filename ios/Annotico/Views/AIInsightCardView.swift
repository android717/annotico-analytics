import SwiftUI

struct AIInsightCardView: View {
    let insight: AIInsight
    let viewModel: AnalyticsViewModel
    let onTap: () -> Void

    private var isCopied: Bool { viewModel.copiedMessageId == insight.id }
    private var isEditing: Bool { viewModel.editingMessageId == insight.id }

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(spacing: 0) {
                accentBar
                cardBody
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(AppColors.border, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private var accentBar: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [insight.group.color, insight.group.lightColor],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 4)
    }

    private var cardBody: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("#\(insight.rank) · \(insight.name)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColors.navy)
                    Text(insight.email)
                        .font(.system(size: 11))
                        .foregroundStyle(AppColors.muted)
                }
                Spacer()
                intentBadge
            }

            scoreRow

            Text("\"\(insight.reasoning)\"")
                .font(.system(size: 12))
                .foregroundStyle(Color(red: 0.23, green: 0.29, blue: 0.42))
                .lineSpacing(3)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.973, green: 0.976, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.navy3)
                        .frame(width: 3)
                        .clipShape(RoundedRectangle(cornerRadius: 1.5))
                }

            if let message = insight.suggestedMessage {
                suggestedMessageSection(message)
            } else {
                noMessageNote
            }
        }
        .padding(16)
    }

    private var intentBadge: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(insight.group.color)
                .frame(width: 7, height: 7)
            Text(insight.group.rawValue)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(insight.group.color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            Group {
                switch insight.group {
                case .callNow: AppColors.greenSoft
                case .followUp: AppColors.amberSoft
                case .watch: AppColors.redSoft
                }
            }
        )
        .clipShape(Capsule())
    }

    private var scoreRow: some View {
        HStack(spacing: 10) {
            Text("AI Score")
                .font(.system(size: 11))
                .foregroundStyle(AppColors.muted)
                .frame(width: 52, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColors.border)
                        .frame(height: 6)
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [insight.group.color, insight.group.lightColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * CGFloat(insight.score) / 100.0, height: 6)
                }
            }
            .frame(height: 6)

            Text("\(insight.score)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(insight.group.color)
                .frame(width: 28, alignment: .trailing)
        }
    }

    private func suggestedMessageSection(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SUGGESTED FOLLOW-UP TEXT")
                .font(.system(size: 10.5, weight: .semibold))
                .foregroundStyle(AppColors.muted)
                .tracking(1)

            let displayMessage = viewModel.editedMessages[insight.id] ?? message

            if isEditing {
                TextField("Edit message...", text: Binding(
                    get: { viewModel.editedMessages[insight.id] ?? message },
                    set: { viewModel.editedMessages[insight.id] = $0 }
                ), axis: .vertical)
                .font(.system(size: 12.5))
                .foregroundStyle(Color(red: 0.17, green: 0.23, blue: 0.36))
                .lineSpacing(3)
                .padding(12)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(AppColors.gold, lineWidth: 1)
                }
            } else {
                Text(displayMessage)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color(red: 0.17, green: 0.23, blue: 0.36))
                    .lineSpacing(3)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.973, green: 0.976, blue: 1.0), Color(red: 0.941, green: 0.957, blue: 1.0)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color(red: 0.867, green: 0.894, blue: 0.961), lineWidth: 1)
                    }
            }

            HStack(spacing: 8) {
                Button {
                    withAnimation(.snappy(duration: 0.2)) {
                        if isEditing {
                            viewModel.editingMessageId = nil
                        } else {
                            viewModel.editingMessageId = insight.id
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: isEditing ? "checkmark" : "pencil")
                            .font(.system(size: 11))
                        Text(isEditing ? "Done" : "Edit")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .foregroundStyle(AppColors.navy)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(AppColors.border, lineWidth: 1.5)
                    }
                }

                Button {
                    viewModel.copyMessage(id: insight.id, text: displayMessage)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 11))
                        Text(isCopied ? "Copied!" : "Copy")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(isCopied ? AppColors.green : AppColors.navy)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private var noMessageNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "info.circle")
                .font(.system(size: 12))
                .foregroundStyle(Color.gray.opacity(0.6))
            Text("Low engagement — no outreach suggested at this time.")
                .font(.system(size: 11.5))
                .foregroundStyle(Color.gray)
                .italic()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color(red: 0.878, green: 0.878, blue: 0.878), lineWidth: 1)
        }
    }
}
