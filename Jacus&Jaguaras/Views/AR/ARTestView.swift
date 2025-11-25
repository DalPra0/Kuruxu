import SwiftUI

struct ARTestView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var onPhotoTaken: (() -> Void)?
    
    func makeUIViewController(context: Context) -> ARTestViewController {
        let controller = ARTestViewController()
        controller.onDismiss = {
            dismiss()
        }
        controller.onPhotoTaken = onPhotoTaken
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ARTestViewController, context: Context) {
    }
}
