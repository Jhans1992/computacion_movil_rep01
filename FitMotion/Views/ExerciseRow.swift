import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Color.accent(exercise.accent).opacity(0.14)
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title).foregroundStyle(Color.accent(exercise.accent))
            }
            .frame(width: 72, height: 72).clipShape(RoundedRectangle(cornerRadius: 18))
            VStack(alignment: .leading, spacing: 6) {
                Text(exercise.name).font(.headline).foregroundStyle(.white)
                Text("\(exercise.muscle.rawValue) · \(exercise.equipment)")
                    .font(.caption).foregroundStyle(.secondary).lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(12).background(Color.fmSurface).clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
