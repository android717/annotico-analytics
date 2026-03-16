import SwiftUI

struct FilterTabsView: View {
    @Binding var selected: FilterType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FilterType.allCases) { filter in
                    Button {
                        withAnimation(.snappy(duration: 0.25)) {
                            selected = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 12.5, weight: .semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .foregroundStyle(selected == filter ? .white : AppColors.muted)
                            .background(selected == filter ? AppColors.navy : .white)
                            .clipShape(Capsule())
                            .overlay {
                                Capsule()
                                    .strokeBorder(selected == filter ? AppColors.navy : AppColors.border, lineWidth: 1.5)
                            }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 0)
    }
}
