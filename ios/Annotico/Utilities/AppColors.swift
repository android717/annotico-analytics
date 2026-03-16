import SwiftUI

enum AppColors {
    static let navy = Color(red: 0.039, green: 0.086, blue: 0.157)
    static let navy2 = Color(red: 0.067, green: 0.133, blue: 0.251)
    static let navy3 = Color(red: 0.102, green: 0.196, blue: 0.329)
    static let gold = Color(red: 0.788, green: 0.659, blue: 0.298)
    static let gold2 = Color(red: 0.910, green: 0.788, blue: 0.416)
    static let goldSoft = Color(red: 0.788, green: 0.659, blue: 0.298).opacity(0.12)
    static let surface = Color(red: 0.957, green: 0.965, blue: 0.980)
    static let border = Color(red: 0.886, green: 0.910, blue: 0.949)
    static let muted = Color(red: 0.478, green: 0.533, blue: 0.600)
    static let green = Color(red: 0.153, green: 0.682, blue: 0.376)
    static let greenSoft = Color(red: 0.929, green: 0.980, blue: 0.957)
    static let amber = Color(red: 0.910, green: 0.580, blue: 0.227)
    static let amberSoft = Color(red: 1.0, green: 0.961, blue: 0.925)
    static let red = Color(red: 0.878, green: 0.322, blue: 0.322)
    static let redSoft = Color(red: 1.0, green: 0.941, blue: 0.941)

    static func scoreColor(for score: Int) -> Color {
        if score >= 70 { return green }
        if score >= 45 { return amber }
        return red
    }
}
