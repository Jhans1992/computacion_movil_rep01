import SwiftUI

struct WorkoutPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    let exercises: [Exercise]
    @State private var index = 0
    @State private var seconds = 40
    @State private var paused = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var current: Exercise { exercises[index] }

    var body: some View {
        ZStack {
            Color.fmBackground.ignoresSafeArea()
            VStack(spacing: 22) {
                HStack {
                    Button("Cerrar") { dismiss() }.foregroundStyle(.secondary)
                    Spacer()
                    Text("\(index + 1) / \(exercises.count)").font(.headline)
                    Spacer()
                    Color.clear.frame(width: 45)
                }
                ProgressView(value: Double(index * 40 + 40 - seconds), total: Double(exercises.count * 40))
                    .tint(.fmLime)
                Spacer()
                RemoteExerciseMedia(url: current.animationURL, tint: .accent(current.accent))
                    .frame(maxHeight: 350)
                Text(current.name).font(.largeTitle.bold()).multilineTextAlignment(.center)
                Text("00:\(String(format: "%02d", seconds))")
                    .font(.system(size: 54, weight: .bold, design: .rounded)).foregroundStyle(.fmLime)
                HStack(spacing: 35) {
                    Button { previous() } label: { Image(systemName: "backward.fill") }
                        .disabled(index == 0)
                    Button { paused.toggle() } label: {
                        Image(systemName: paused ? "play.fill" : "pause.fill")
                            .font(.title).frame(width: 72, height: 72).background(Color.fmLime)
                            .foregroundStyle(.black).clipShape(Circle())
                    }
                    Button { next() } label: { Image(systemName: "forward.fill") }
                        .disabled(index == exercises.count - 1)
                }.font(.title2).foregroundStyle(.white)
                Spacer()
            }.padding()
        }
        .onReceive(timer) { _ in
            guard !paused else { return }
            if seconds > 0 { seconds -= 1 } else if index < exercises.count - 1 { next() } else { paused = true }
        }
    }

    private func next() { guard index < exercises.count - 1 else { return }; index += 1; seconds = 40 }
    private func previous() { guard index > 0 else { return }; index -= 1; seconds = 40 }
}
