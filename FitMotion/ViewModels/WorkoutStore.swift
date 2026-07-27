import Foundation

@MainActor
final class WorkoutStore: ObservableObject {
    @Published private(set) var routine: [Exercise]
    @Published private(set) var favoriteIDs: Set<String>

    private let defaults: UserDefaults
    private let routineKey = "fitmotion.routine"
    private let favoritesKey = "fitmotion.favorites"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let decoder = JSONDecoder()
        routine = defaults.data(forKey: routineKey)
            .flatMap { try? decoder.decode([Exercise].self, from: $0) } ?? []
        favoriteIDs = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
    }

    func toggleInRoutine(_ exercise: Exercise) {
        if let index = routine.firstIndex(of: exercise) {
            routine.remove(at: index)
        } else {
            routine.append(exercise)
        }
        persistRoutine()
    }

    func contains(_ exercise: Exercise) -> Bool { routine.contains(exercise) }

    func toggleFavorite(_ exercise: Exercise) {
        if favoriteIDs.contains(exercise.id) {
            favoriteIDs.remove(exercise.id)
        } else {
            favoriteIDs.insert(exercise.id)
        }
        defaults.set(Array(favoriteIDs), forKey: favoritesKey)
    }

    func isFavorite(_ exercise: Exercise) -> Bool { favoriteIDs.contains(exercise.id) }

    func removeFromRoutine(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) { routine.remove(at: index) }
        persistRoutine()
    }

    private func persistRoutine() {
        defaults.set(try? JSONEncoder().encode(routine), forKey: routineKey)
    }
}
