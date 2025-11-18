import UIKit
import AVFoundation

class ARFeedbackManager {
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    init() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
    }
    
    func cardDetected() {
        impactLight.impactOccurred()
        AudioServicesPlaySystemSound(1104)
    }
    
    func markerCreated() {
        impactMedium.impactOccurred()
        AudioServicesPlaySystemSound(1057)
    }
    
    func constellationDetected() {
        notificationGenerator.notificationOccurred(.success)
        AudioServicesPlaySystemSound(1256)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            AudioServicesPlaySystemSound(1257)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
            AudioServicesPlaySystemSound(1258)
        }
    }
    
    func constellationLost() {
        notificationGenerator.notificationOccurred(.warning)
        AudioServicesPlaySystemSound(1053)
    }
    
    func cardRemoved() {
        impactLight.impactOccurred()
        AudioServicesPlaySystemSound(1105)
    }
    
    func markerMoved() {
        impactLight.impactOccurred(intensity: 0.5)
    }
}
