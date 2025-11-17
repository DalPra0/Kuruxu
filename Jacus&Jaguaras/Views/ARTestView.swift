import SwiftUI

struct ARTestView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARTestViewController {
        return ARTestViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARTestViewController, context: Context) {
    }
}
