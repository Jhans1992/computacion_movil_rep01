import SwiftUI

struct ExploreView: View {
    @State private var query = ""
    @State private var selected: MuscleGroup?

    private var filtered: [Exercise] {
        ExerciseCatalog.exercises.filter { exercise in
            (selected == nil || exercise.muscle == selected) &&
            (query.isEmpty || exercise.name.localizedCaseInsensitiveContains(query))
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Explorar ejercicios").font(.largeTitle.bold())
                Text("Encuentra el movimiento ideal para tu objetivo.")
                    .foregroundStyle(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        filterChip("Todos", active: selected == nil) { selected = nil }
                        ForEach(MuscleGroup.allCases) { group in
                            filterChip(group.rawValue, active: selected == group) { selected = group }
                        }
                    }
                }
                LazyVStack(spacing: 12) {
                    ForEach(filtered) { exercise in
                        NavigationLink(value: exercise) { ExerciseRow(exercise: exercise) }
                            .buttonStyle(.plain)
                    }
                }
            }.padding()
        }
        .searchable(text: $query, prompt: "Buscar ejercicio")
        .background(Color.fmBackground.ignoresSafeArea())
        .navigationDestination(for: Exercise.self) { ExerciseDetailView(exercise: $0) }
    }

    private func filterChip(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .font(.subheadline.bold()).foregroundStyle(active ? Color.black : Color.white)
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(active ? Color.fmLime : Color.fmSurface).clipShape(Capsule())
    }
}
