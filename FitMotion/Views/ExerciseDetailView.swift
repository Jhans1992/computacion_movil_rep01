import SwiftUI

struct ExerciseDetailView: View {
    @EnvironmentObject private var store: WorkoutStore
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                RemoteExerciseMedia(url: exercise.animationURL, tint: .accent(exercise.accent))
                    .frame(height: 300)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 7) {
                        Text(exercise.name).font(.largeTitle.bold())
                        Text("\(exercise.muscle.rawValue)  ·  \(exercise.equipment)")
                            .foregroundStyle(Color.accent(exercise.accent))
                    }
                    Spacer()
                    Button { store.toggleFavorite(exercise) } label: {
                        Image(systemName: store.isFavorite(exercise) ? "heart.fill" : "heart")
                            .font(.title2).foregroundStyle(.pink)
                    }
                }
                Text("Cómo hacerlo").font(.title2.bold())
                ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 14) {
                        Text("\(index + 1)").font(.headline).foregroundStyle(.black)
                            .frame(width: 32, height: 32).background(Color.accent(exercise.accent)).clipShape(Circle())
                        Text(step).foregroundStyle(.white.opacity(0.85)).padding(.top, 5)
                    }
                }
                Button { store.toggleInRoutine(exercise) } label: {
                    Label(store.contains(exercise) ? "Quitar de mi rutina" : "Agregar a mi rutina",
                          systemImage: store.contains(exercise) ? "minus" : "plus")
                    .frame(maxWidth: .infinity).font(.headline).padding()
                    .foregroundStyle(.black).background(Color.fmLime).clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }.padding()
        }
        .background(Color.fmBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
