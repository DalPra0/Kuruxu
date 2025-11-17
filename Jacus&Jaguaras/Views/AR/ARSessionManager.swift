import UIKit
import ARKit
import SceneKit

class ARSessionManager {
    weak var sceneView: ARSCNView?
    var totalCardsAvailable: Int = 0
    
    func startSession(completion: @escaping (Bool, String?) -> Void) {
        var referenceImages: Set<ARReferenceImage> = []
        
        guard let arAssets = ARReferenceImage.referenceImages(inGroupNamed: "Cartas", bundle: nil) else {
            print("ERRO: Pasta 'Cartas' não encontrada no Assets!")
            print("   Crie um AR Resource Group chamado 'Cartas' no Assets.xcassets")
            print("   e adicione as imagens de cartas lá")
            completion(false, "Pasta 'Cartas' não encontrada! Adicione imagens no Assets.")
            return
        }
        
        if true {
            referenceImages = arAssets
            totalCardsAvailable = referenceImages.count
            
            print("===========================================")
            print("CARTAS CARREGADAS DA PASTA 'Cartas':")
            print("   Total: \(totalCardsAvailable) cartas")
            print("-------------------------------------------")
            for (index, image) in referenceImages.enumerated() {
                print("   [\(index + 1)] \(image.name ?? "sem_nome")")
                print("       Tamanho: \(String(format: "%.3f", image.physicalSize.width))m")
            }
            print("===========================================")
            
        } else {
            print("ERRO: Não foi possível carregar imagens AR")
            print("   As imagens precisam estar em AR Resources")
            completion(false, "Configure as imagens como AR Resources no Assets!")
            return
        }
        
        guard !referenceImages.isEmpty else {
            completion(false, "Nenhuma carta encontrada! Adicione imagens na pasta Cartas.")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = min(totalCardsAvailable, 6)
        configuration.isAutoFocusEnabled = true
        
        sceneView?.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        print("\nSessão AR iniciada!")
        print("Detectando até \(configuration.maximumNumberOfTrackedImages) cartas simultâneas")
        
        completion(true, nil)
    }
    
    func pauseSession() {
        sceneView?.session.pause()
    }
}
