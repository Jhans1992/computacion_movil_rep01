import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let muscle: MuscleGroup
    let equipment: String
    let instructions: [String]
    let animationURL: URL?
    let accent: AccentColor

    enum AccentColor: String, Codable, CaseIterable {
        case lime, coral, cyan, violet
    }
}

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case fullBody = "Cuerpo completo"
    case legs = "Piernas"
    case chest = "Pecho"
    case back = "Espalda"
    case core = "Core"
    case arms = "Brazos"

    var id: String { rawValue }
}
