import XCTest
@testable import FitMotion

@MainActor
final class WorkoutStoreTests: XCTestCase {
    func testRoutineAndFavoritesPersist() {
        let suite = "WorkoutStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        let exercise = ExerciseCatalog.exercises[0]
        let store = WorkoutStore(defaults: defaults)

        store.toggleInRoutine(exercise)
        store.toggleFavorite(exercise)

        let restored = WorkoutStore(defaults: defaults)
        XCTAssertTrue(restored.contains(exercise))
        XCTAssertTrue(restored.isFavorite(exercise))
    }

    func testTogglingRoutineRemovesExistingExercise() {
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        let store = WorkoutStore(defaults: defaults)
        let exercise = ExerciseCatalog.exercises[0]
        store.toggleInRoutine(exercise)
        store.toggleInRoutine(exercise)
        XCTAssertTrue(store.routine.isEmpty)
    }
}
