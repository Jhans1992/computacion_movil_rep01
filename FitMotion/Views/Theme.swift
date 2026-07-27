import SwiftUI

extension Color {
    static let fmBackground = Color(red: 0.035, green: 0.047, blue: 0.055)
    static let fmSurface = Color(red: 0.075, green: 0.09, blue: 0.10)
    static let fmLime = Color(red: 0.72, green: 0.96, blue: 0.20)

    static func accent(_ value: Exercise.AccentColor) -> Color {
        switch value {
        case .lime: .fmLime
        case .coral: Color(red: 1, green: 0.39, blue: 0.34)
        case .cyan: Color(red: 0.18, green: 0.83, blue: 0.93)
        case .violet: Color(red: 0.66, green: 0.48, blue: 1)
        }
    }
}
