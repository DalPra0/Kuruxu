import UIKit
import ARKit
import SceneKit

class ARSessionManager {
    weak var sceneView: ARSCNView?
    var totalCardsAvailable: Int = 0
    
    func startSession(completion: @escaping (Bool, String?) -> Void) {
        print("🚀 Iniciando sessão AR...")
        
        guard let sceneView = sceneView else {
            print("❌ ERRO: sceneView é nil!")
            completion(false, "SceneView não configurada")
            return
        }
        
        print("✅ SceneView encontrada: \(sceneView)")
        
        var referenceImages: Set<ARReferenceImage> = []
        
        guard let arAssets = ARReferenceImage.referenceImages(inGroupNamed: "Cartas", bundle: nil) else {
            print("ERRO: Pasta 'Cartas' não encontrada no Assets!")
            print("   Crie um AR Resource Group chamado 'Cartas' no Assets.xcassets")
            print("   e adicione as imagens de cartas lá")
            completion(false, "Pasta 'Cartas' não encontrada! Adicione imagens no Assets.")
            return
        }
        
        referenceImages = arAssets.filter { image in
            let hasValidSize = image.physicalSize.width > 0 && image.physicalSize.height > 0
            if !hasValidSize {
                print("⚠️ IGNORANDO imagem inválida: \(image.name ?? "sem_nome") (tamanho: \(image.physicalSize.width)m)")
            }
            return hasValidSize
        }
        
        totalCardsAvailable = referenceImages.count
        
        print("===========================================")
        print("CARTAS VÁLIDAS CARREGADAS:")
        print("   Total: \(totalCardsAvailable) cartas")
        print("-------------------------------------------")
        for (index, image) in referenceImages.enumerated() {
            print("   [\(index + 1)] \(image.name ?? "sem_nome")")
            print("       Tamanho: \(String(format: "%.3f", image.physicalSize.width))m")
        }
        print("===========================================")
            print("===========================================")
        
        guard !referenceImages.isEmpty else {
            print("❌ ERRO: Nenhuma carta válida encontrada!")
            completion(false, "Nenhuma carta válida! Configure o tamanho físico das imagens no Assets.")
            return
        }
        
        let configuration = ARWorldTrackingConfiguration()
        
        guard ARWorldTrackingConfiguration.isSupported else {
            print("❌ ERRO: ARWorldTracking não suportado neste dispositivo!")
            completion(false, "ARKit não suportado")
            return
        }
        
        print("✅ ARWorldTracking suportado")
        
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = min(totalCardsAvailable, 6)
        configuration.isAutoFocusEnabled = true
        
        print("🎬 Iniciando session.run()...")
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("✅ Session.run() chamado!")
        
        print("\nSessão AR iniciada!")
        print("Detectando até \(configuration.maximumNumberOfTrackedImages) cartas simultâneas")
        
        completion(true, nil)
    }
    
    func pauseSession() {
        sceneView?.session.pause()
    }
}
