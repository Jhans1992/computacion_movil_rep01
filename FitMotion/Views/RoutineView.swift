import SwiftUI

struct RoutineView: View {
    @EnvironmentObject private var store: WorkoutStore
    @State private var showingPlayer = false

    var body: some View {
        Group {
            if store.routine.isEmpty { emptyState } else { routineList }
        }
        .background(Color.fmBackground.ignoresSafeArea())
        .navigationTitle("Mi rutina")
        .fullScreenCover(isPresented: $showingPlayer) { WorkoutPlayerView(exercises: store.routine) }
    }

    private var routineList: some View {
        VStack(spacing: 14) {
            List {
                Section("\(store.routine.count) ejercicios · 40 s cada uno") {
                    ForEach(store.routine) { ExerciseRow(exercise: $0).listRowBackground(Color.clear) }
                        .onDelete(perform: store.removeFromRoutine)
                }
            }
            .scrollContentBackground(.hidden).listStyle(.plain)
            Button { showingPlayer = true } label: {
                Label("Comenzar entrenamiento", systemImage: "play.fill")
                    .frame(maxWidth: .infinity).padding().font(.headline)
                    .foregroundStyle(.black).background(Color.fmLime).clipShape(RoundedRectangle(cornerRadius: 16))
            }.padding([.horizontal, .bottom])
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Tu rutina está vacía", systemImage: "figure.cooldown")
        } description: {
            Text("Explora ejercicios y agrega tus favoritos para comenzar.")
        }
    }
}
