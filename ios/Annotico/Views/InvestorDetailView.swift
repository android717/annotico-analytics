import SwiftUI

struct InvestorDetailView: View {
    let investor: Investor
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: DetailTab = .engagement
    @State private var copiedDetailMsg = false
    @State private var editingDetailMsg = false
    @State private var editedDetailMsg: String = ""

    var body: some View {
        VStack(spacing: 0) {
            TopNavBar(showBack: true) {
                dismiss()
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    heroCard
                    disclaimerBanner
                    tabSelector
                    tabContent
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            .background(AppColors.surface)
            .scrollIndicators(.hidden)
        }
        .navigationBarHidden(true)
        .onAppear {
            editedDetailMsg = "Hi, just checking in — have you had a chance to think it over? Happy to answer any questions whenever you're ready."
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(investor.name)
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    Text(investor.email)
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.45))
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(investor.badge.color)
                            .frame(width: 7, height: 7)
                        Text(investor.badge.rawValue)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(investor.badge.color)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(investor.badge.softColor)
                    .clipShape(Capsule())

                    HStack(spacing: 8) {
                        Text("AI Score")
                            .font(.system(size: 11))
                            .foregroundStyle(.white.opacity(0.4))
                        Text("\(investor.aiScore)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(investor.badge.color)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.08))
                    .clipShape(Capsule())
                }
            }

            HStack(spacing: 24) {
                statItem(value: "\(investor.revisits)", label: "Revisits")
                statItem(value: investor.totalTime, label: "Total Engagement")
                statItem(value: "\(investor.coviewers)", label: "Co-viewers")
                statItem(value: "\(investor.enquiries)", label: "Enquiries")
            }
        }
        .padding(20)
        .background(AppColors.navy)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.gold)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.4))
        }
    }

    private var disclaimerBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 12))
                .foregroundStyle(Color(red: 0.478, green: 0.376, blue: 0.125))
            Text("Annotico analyses engagement signals to help you prioritise. All decisions remain yours.")
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

    private var tabSelector: some View {
        HStack(spacing: 4) {
            ForEach(DetailTab.allCases) { tab in
                Button {
                    withAnimation(.snappy(duration: 0.25)) {
                        selectedTab = tab
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(size: 11, weight: .semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.vertical, 9)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selectedTab == tab ? .white : AppColors.muted)
                        .background(selectedTab == tab ? AppColors.navy : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                }
            }
        }
        .padding(4)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .engagement:
            engagementTab
        case .timeline:
            timelineTab
        case .coviewers:
            coviewersTab
        case .enquiries:
            enquiriesTab
        case .aiInsights:
            aiInsightsTab
        }
    }

    // MARK: - Engagement Tab
    private var engagementTab: some View {
        VStack(spacing: 14) {
            cardContainer(title: "Project Engagement", icon: "building.2") {
                VStack(spacing: 0) {
                    projectRow(code: "P1", name: "Parkland V2", meta: "3 sessions · Last visited 2 hours ago", percent: 0.85, time: "32 min")
                    Divider().foregroundStyle(AppColors.border)
                    projectRow(code: "P2", name: "Creek Harbour", meta: "2 sessions · Last visited yesterday", percent: 0.40, time: "15 min")
                }
            }

            cardContainer(title: "Content Breakdown", icon: "doc.text") {
                let columns = [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
                LazyVGrid(columns: columns, spacing: 10) {
                    contentItem(type: "PDF", name: "Brochure PDF", detail: "Page 4 most viewed · 12 min", percent: 0.80, color: AppColors.navy)
                    contentItem(type: "PAYMENT", name: "Payment Plan", detail: "Viewed 3 times · 8 min", percent: 0.65, color: AppColors.gold)
                    contentItem(type: "IMAGE", name: "Living Room", detail: "4 min · Most time on image", percent: 0.50, color: Color(red: 0.23, green: 0.51, blue: 0.96))
                    contentItem(type: "VIDEO", name: "Project Video", detail: "Watched 2:30 of 3:00", percent: 0.83, color: Color(red: 0.55, green: 0.36, blue: 0.96))
                    contentItem(type: "360°", name: "360° Tour", detail: "Bedroom area · 6 min", percent: 0.45, color: Color(red: 0.06, green: 0.73, blue: 0.51))
                    contentItem(type: "FLOOR", name: "Floor Plan", detail: "2BHK focused · 5 min", percent: 0.38, color: Color(red: 0.96, green: 0.62, blue: 0.04))
                }
            }
        }
        .transition(.opacity)
    }

    private func projectRow(code: String, name: String, meta: String, percent: Double, time: String) -> some View {
        HStack(spacing: 14) {
            Text(code)
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(AppColors.gold)
                .frame(width: 36, height: 36)
                .background(AppColors.navy2)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(AppColors.navy)
                Text(meta)
                    .font(.system(size: 11.5))
                    .foregroundStyle(AppColors.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 2) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(AppColors.border).frame(height: 5)
                        Capsule().fill(AppColors.gold).frame(width: geo.size.width * percent, height: 5)
                    }
                }
                .frame(width: 80, height: 5)
                Text(time)
                    .font(.system(size: 11))
                    .foregroundStyle(AppColors.muted)
            }
        }
        .padding(.vertical, 12)
    }

    private func contentItem(type: String, name: String, detail: String, percent: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(type)
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.navy)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(AppColors.navy)
            Text(detail)
                .font(.system(size: 11))
                .foregroundStyle(AppColors.muted)
                .lineLimit(2)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(AppColors.border).frame(height: 3)
                    Capsule().fill(color).frame(width: geo.size.width * percent, height: 3)
                }
            }
            .frame(height: 3)
            .padding(.top, 4)
        }
        .padding(12)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    // MARK: - Timeline Tab
    private var timelineTab: some View {
        cardContainer(title: "Activity Timeline", icon: "clock") {
            VStack(alignment: .leading, spacing: 0) {
                timelineItem(color: AppColors.green, date: "Today · 9:14 AM", event: "5th Revisit — Parkland V2", detail: "22 min session · Payment Plan viewed again · Enquiry sent", isLast: false)
                timelineItem(color: AppColors.gold, date: "Yesterday · 8:45 PM", event: "Co-viewer Session — Parkland V2", detail: "2 co-viewers joined · 38 min combined · 1 used Lock Mode · Annotation added", isLast: false)
                timelineItem(color: AppColors.navy3, date: "2 days ago · 3:20 PM", event: "Video + 360° Tour — Creek Harbour", detail: "15 min · Watched full video · Explored bedroom in 360° tour", isLast: false)
                timelineItem(color: AppColors.navy3, date: "3 days ago · 11:05 AM", event: "First Session — Parkland V2", detail: "10 min · Brochure PDF · Floor plan viewed", isLast: false)
                timelineItem(color: AppColors.muted, date: "3 days ago · 10:30 AM", event: "Portal Opened for first time", detail: "Link received via WhatsApp · Opened immediately", isLast: true)
            }
        }
        .transition(.opacity)
    }

    private func timelineItem(color: Color, date: String, event: String, detail: String, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)
                    .overlay {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                    }
                if !isLast {
                    Rectangle()
                        .fill(AppColors.border)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(date.uppercased())
                    .font(.system(size: 10.5, weight: .bold))
                    .foregroundStyle(AppColors.muted)
                    .tracking(0.5)

                VStack(alignment: .leading, spacing: 3) {
                    Text(event)
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundStyle(AppColors.navy)
                    Text(detail)
                        .font(.system(size: 11.5))
                        .foregroundStyle(AppColors.muted)
                        .lineSpacing(2)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(AppColors.border, lineWidth: 1)
                }
            }
        }
        .padding(.bottom, isLast ? 0 : 18)
    }

    // MARK: - Co-viewers Tab
    private var coviewersTab: some View {
        cardContainer(title: "Co-viewer Activity", icon: "person.2") {
            VStack(spacing: 0) {
                coviewerRow(code: "C1", name: "Co-viewer 1", meta: ["22 min", "Parkland V2", "Yesterday 8:45 PM"], tags: [("Lock Mode", AppColors.greenSoft, Color(red: 0.09, green: 0.40, blue: 0.20)), ("Payment Plan", AppColors.amberSoft, Color(red: 0.57, green: 0.25, blue: 0.05))], isLast: false)
                Divider().foregroundStyle(AppColors.border)
                coviewerRow(code: "C2", name: "Co-viewer 2", meta: ["16 min", "Parkland V2", "Yesterday 9:02 PM"], tags: [("Images", Color(red: 0.94, green: 0.98, blue: 1.0), Color(red: 0.03, green: 0.35, blue: 0.52)), ("Video", Color(red: 0.99, green: 0.95, blue: 0.97), Color(red: 0.53, green: 0.10, blue: 0.56))], isLast: false)
                Divider().foregroundStyle(AppColors.border)
                coviewerRow(code: "C3", name: "Co-viewer 3", meta: ["Invited · Did not join", "2 days ago"], tags: [], isLast: true)
            }
        }
        .transition(.opacity)
    }

    private func coviewerRow(code: String, name: String, meta: [String], tags: [(String, Color, Color)], isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(code)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.gold)
                .frame(width: 36, height: 36)
                .background(AppColors.navy2)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(name)
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(AppColors.navy)

                HStack(spacing: 10) {
                    ForEach(meta, id: \.self) { m in
                        Text(m)
                            .font(.system(size: 11.5))
                            .foregroundStyle(AppColors.muted)
                    }
                }

                if !tags.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(tags, id: \.0) { tag in
                            Text(tag.0)
                                .font(.system(size: 10.5, weight: .semibold))
                                .foregroundStyle(tag.2)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(tag.1)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 3)
                }
            }
        }
        .padding(.vertical, 12)
    }

    // MARK: - Enquiries Tab
    private var enquiriesTab: some View {
        VStack(spacing: 14) {
            cardContainer(title: "Enquiries Sent", icon: "envelope") {
                VStack(spacing: 10) {
                    enquiryItem(project: "Parkland V2", date: "Today 9:14 AM", context: "Payment Plan · Page 2",
                                text: "Can the payment plan be structured differently? We would prefer 60/40. Also, is the handover date flexible?")
                    enquiryItem(project: "Parkland V2", date: "Yesterday 8:50 PM", context: "Floor Plan · 2BHK",
                                text: "What is the exact sq ft of the 2BHK with terrace? Is there a corner unit on a higher floor?")
                }
            }

            cardContainer(title: "Annotations", icon: "pin") {
                VStack(spacing: 10) {
                    annotationItem(pin: "Floor Plan · 2BHK", author: "Ahmed Al Mansouri", date: "Yesterday 8:52 PM",
                                   text: "This layout works. Need to check if we can modify the kitchen wall.")
                    annotationItem(pin: "Payment Plan · Page 2", author: "Co-viewer 1", date: "Yesterday 9:05 PM",
                                   text: "Ask about post-handover payment options.")
                    annotationItem(pin: "360° Tour · Bedroom", author: "Ahmed Al Mansouri", date: "2 days ago 3:28 PM",
                                   text: "Window size seems small. Confirm natural light.")
                }
            }
        }
        .transition(.opacity)
    }

    private func enquiryItem(project: String, date: String, context: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 10) {
                Text(project).font(.system(size: 10.5)).foregroundStyle(AppColors.muted)
                Text(date).font(.system(size: 10.5)).foregroundStyle(AppColors.muted)
                Text(context).font(.system(size: 10.5)).foregroundStyle(AppColors.muted)
            }
            Text("\"\(text)\"")
                .font(.system(size: 13))
                .foregroundStyle(AppColors.navy)
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(AppColors.gold)
                .frame(width: 3)
                .clipShape(RoundedRectangle(cornerRadius: 1.5))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    private func annotationItem(pin: String, author: String, date: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .font(.system(size: 9))
                Text(pin)
                    .font(.system(size: 10.5, weight: .semibold))
            }
            .foregroundStyle(Color(red: 0.23, green: 0.31, blue: 0.66))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color(red: 0.93, green: 0.95, blue: 1.0))
            .clipShape(Capsule())

            HStack(spacing: 10) {
                Text(author).font(.system(size: 10.5)).foregroundStyle(AppColors.muted)
                Text(date).font(.system(size: 10.5)).foregroundStyle(AppColors.muted)
            }
            Text("\"\(text)\"")
                .font(.system(size: 13))
                .foregroundStyle(AppColors.navy)
                .lineSpacing(3)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(AppColors.navy3)
                .frame(width: 3)
                .clipShape(RoundedRectangle(cornerRadius: 1.5))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    // MARK: - AI Insights Tab
    private var aiInsightsTab: some View {
        cardContainer(title: "AI Analysis", icon: "brain") {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("AI REASONING")
                        .font(.system(size: 10.5, weight: .bold))
                        .foregroundStyle(AppColors.navy3)
                        .tracking(1)
                    Text("\"5 revisits across 3 days, payment plan viewed 3 times, 2 co-viewers joined with Lock Mode, 2 specific enquiries about payment structure and unit selection — strong indicators of active buying consideration moving toward decision.\"")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(red: 0.17, green: 0.23, blue: 0.36))
                        .lineSpacing(3)
                        .italic()
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 0.973, green: 0.976, blue: 1.0))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.navy3)
                        .frame(width: 4)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack(spacing: 12) {
                    statPill(value: "\(investor.aiScore)", label: "AI Score", valueColor: investor.badge.color)
                    VStack(spacing: 6) {
                        Circle()
                            .fill(investor.badge.color)
                            .frame(width: 10, height: 10)
                        Text(investor.badge.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(investor.badge.color)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(investor.badge.softColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(AppColors.border, lineWidth: 1)
                    }
                    statPill(value: "#\(investor.rank)", label: "Priority Rank", valueColor: AppColors.navy)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("SUGGESTED FOLLOW-UP TEXT")
                        .font(.system(size: 10.5, weight: .semibold))
                        .foregroundStyle(AppColors.muted)
                        .tracking(1)

                    if editingDetailMsg {
                        TextField("Edit message...", text: $editedDetailMsg, axis: .vertical)
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
                        Text(editedDetailMsg)
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
                                editingDetailMsg.toggle()
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: editingDetailMsg ? "checkmark" : "pencil")
                                    .font(.system(size: 11))
                                Text(editingDetailMsg ? "Done" : "Edit")
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
                            UIPasteboard.general.string = editedDetailMsg
                            copiedDetailMsg = true
                            Task {
                                try? await Task.sleep(for: .seconds(2))
                                copiedDetailMsg = false
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: copiedDetailMsg ? "checkmark" : "doc.on.doc")
                                    .font(.system(size: 11))
                                Text(copiedDetailMsg ? "Copied!" : "Copy Message")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(.white)
                            .background(copiedDetailMsg ? AppColors.green : AppColors.navy)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
        .transition(.opacity)
    }

    private func statPill(value: String, label: String, valueColor: Color) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundStyle(valueColor)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(AppColors.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
    }

    // MARK: - Card Container
    private func cardContainer<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.navy)
                Text(title)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(AppColors.navy)
            }
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(AppColors.border, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}
