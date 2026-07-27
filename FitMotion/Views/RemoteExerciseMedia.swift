import SwiftUI

struct RemoteExerciseMedia: View {
    let url: URL?
    let tint: Color

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.7)) { context in
            let frame = Int(context.date.timeIntervalSinceReferenceDate / 0.7) % 2
            remoteFrame(url: frameURL(frame))
        }
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .accessibilityLabel("Demostración animada del ejercicio")
    }

    @ViewBuilder
    private func remoteFrame(url: URL?) -> some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeInOut(duration: 0.2))) { phase in
            switch phase {
            case .success(let image):
                image.resizable().scaledToFit()
            case .failure:
                placeholder(systemName: "wifi.slash")
            case .empty:
                ZStack { tint.opacity(0.12); ProgressView().tint(tint) }
            @unknown default:
                placeholder(systemName: "figure.strengthtraining.traditional")
            }
        }
    }

    private func frameURL(_ frame: Int) -> URL? {
        guard let url else { return nil }
        return URL(string: url.absoluteString.replacingOccurrences(of: "/0.jpg", with: "/\(frame).jpg"))
    }

    private func placeholder(systemName: String) -> some View {
        ZStack {
            tint.opacity(0.12)
            VStack(spacing: 10) {
                Image(systemName: systemName).font(.system(size: 54)).foregroundStyle(tint)
                Text("Vista previa no disponible").font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
