import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                NavigationLink(destination: RoutineView()) {
                    featuredCard
                }
                sectionTitle("Recomendados", subtitle: "Movimientos para empezar hoy")
                ForEach(ExerciseCatalog.exercises.prefix(3)) { exercise in
                    NavigationLink(value: exercise) { ExerciseRow(exercise: exercise) }
                        .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .background(Color.fmBackground.ignoresSafeArea())
        .navigationDestination(for: Exercise.self) { ExerciseDetailView(exercise: $0) }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("BUEN ENTRENAMIENTO")
                    .font(.caption.bold()).tracking(1.5).foregroundStyle(.fmLime)
                Text("¡Vamos a movernos!")
                    .font(.title.bold())
            }
            Spacer()
            Image(systemName: "bolt.heart.fill")
                .font(.title2).foregroundStyle(.fmLime)
                .frame(width: 48, height: 48).background(Color.fmSurface).clipShape(Circle())
        }
    }

    private var featuredCard: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.fmLime.opacity(0.85), .cyan.opacity(0.35), .fmSurface],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: "figure.run")
                .font(.system(size: 135, weight: .thin))
                .foregroundStyle(.white.opacity(0.2)).offset(x: 180, y: -10)
            VStack(alignment: .leading, spacing: 8) {
                Label("RUTINA DEL DÍA", systemImage: "flame.fill")
                    .font(.caption.bold()).tracking(1)
                Text(store.routine.isEmpty ? "Full body\npara comenzar" : "Tu rutina\nestá lista")
                    .font(.title.bold()).foregroundStyle(.white)
                Text(store.routine.isEmpty ? "7 ejercicios · 24 min" : "\(store.routine.count) ejercicios")
                    .font(.subheadline).foregroundStyle(.white.opacity(0.8))
                Text("COMENZAR  →").font(.subheadline.bold()).padding(.top, 6)
            }
            .padding(22)
        }
        .frame(height: 240).clipShape(RoundedRectangle(cornerRadius: 28))
    }

    private func sectionTitle(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title).font(.title2.bold())
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
        }
    }
}
