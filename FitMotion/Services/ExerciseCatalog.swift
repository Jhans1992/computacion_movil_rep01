import Foundation

enum ExerciseCatalog {
    private static let assetRoot = "https://cdn.jsdelivr.net/gh/yuhonas/free-exercise-db@main/exercises"

    static let exercises: [Exercise] = [
        exercise("air-squat", "Sentadilla libre", .legs, "Sin equipo", "Bodyweight_Squat", [
            "Separa los pies al ancho de los hombros.",
            "Lleva la cadera hacia atrás manteniendo el pecho elevado.",
            "Empuja el suelo y vuelve a la posición inicial."
        ], .lime),
        exercise("push-up", "Flexiones", .chest, "Sin equipo", "Pushups", [
            "Apoya las manos ligeramente más abiertas que los hombros.",
            "Mantén el cuerpo alineado y baja de forma controlada.",
            "Extiende los brazos sin bloquear los codos."
        ], .coral),
        exercise("mountain-climber", "Escaladores", .fullBody, "Sin equipo", "Mountain_Climbers", [
            "Comienza en plancha alta.",
            "Acerca una rodilla al pecho y alterna las piernas.",
            "Mantén la cadera estable durante todo el movimiento."
        ], .cyan),
        exercise("plank", "Plancha", .core, "Sin equipo", "Plank", [
            "Apoya antebrazos y puntas de los pies.",
            "Activa abdomen y glúteos.",
            "Conserva una línea recta desde la cabeza hasta los talones."
        ], .violet),
        exercise("jumping-jack", "Saltos de tijera", .fullBody, "Sin equipo", "Jumping_Jacks", [
            "Inicia de pie con los brazos a los lados.",
            "Salta separando los pies y lleva las manos arriba.",
            "Regresa suavemente a la posición inicial."
        ], .lime),
        exercise("dumbbell-row", "Remo con mancuerna", .back, "Mancuerna", "Dumbbell_Incline_Row", [
            "Apoya una mano y una rodilla sobre un banco.",
            "Lleva la mancuerna hacia la cadera.",
            "Baja el peso lentamente manteniendo la espalda neutra."
        ], .cyan),
        exercise("biceps-curl", "Curl de bíceps", .arms, "Mancuernas", "Dumbbell_Bicep_Curl", [
            "Mantén los codos pegados al torso.",
            "Flexiona los brazos sin mover los hombros.",
            "Desciende las mancuernas de forma controlada."
        ], .coral)
    ]

    private static func exercise(
        _ id: String,
        _ name: String,
        _ muscle: MuscleGroup,
        _ equipment: String,
        _ asset: String,
        _ instructions: [String],
        _ accent: Exercise.AccentColor
    ) -> Exercise {
        let encoded = asset.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? asset
        let url = URL(string: "\(assetRoot)/\(encoded)/0.jpg")
        return Exercise(id: id, name: name, muscle: muscle, equipment: equipment,
                        instructions: instructions, animationURL: url, accent: accent)
    }
}
