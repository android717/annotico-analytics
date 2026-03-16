import SwiftUI

struct TopNavBar: View {
    var showBack: Bool = false
    var onBack: (() -> Void)?

    var body: some View {
        HStack {
            if showBack {
                Button {
                    onBack?()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Back")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(.white.opacity(0.6))
                }
            }

            Spacer()

            Text("annotico")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.gold)
                .tracking(1)

            Spacer()

            if !showBack {
                HStack(spacing: 16) {
                    Text("Rajesh Mehta")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                        .lineLimit(1)

                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                        Circle()
                            .fill(AppColors.gold)
                            .frame(width: 8, height: 8)
                            .offset(x: -4, y: 4)
                    }
                }
            } else {
                Color.clear.frame(width: 60)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(AppColors.navy)
    }
}
