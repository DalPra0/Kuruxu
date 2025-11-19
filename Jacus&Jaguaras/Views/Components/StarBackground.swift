import CoreMotion
import SwiftUI
import Combine

class MotionManager: ObservableObject {
    private var manager = CMMotionManager()

    @Published var x: CGFloat = 0
    @Published var y: CGFloat = 0

    init() {
        manager.startDeviceMotionUpdates(to: .main) { data, _ in
            if let data = data {
                self.x = data.gravity.x
                self.y = data.gravity.y
            }
        }
    }
}


struct StarBackground: View {
    let images = ["starBackground", "starBackground02", "starBackground03"]
//    let images = ["starBackground", "starBackground03", "starBackground04"]

    @State private var index = 0
    @State private var brightness = 0.8
    @StateObject private var motion = MotionManager()

    var body: some View {
        ZStack {
            ForEach(images.indices, id: \.self) { i in
                Image(images[i])
                    .resizable()
                    .scaledToFill()
                    .opacity(i == index ? brightness : 0.5)
                    .offset(x: motion.x * 50, y: motion.y * 50)
                    .animation(.easeInOut(duration: 1), value: index)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                index = (index + 1) % images.count
            }

            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                brightness = 1.0
            }
        }
    }
}
