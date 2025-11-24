//
//  LevelSelectionView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI
import AVFoundation

struct StartView: View {
    let screenSize = UIScreen.main.bounds
    @State private var showButton = false
    @State private var navigateToConstellation = false
    @State private var showPermissionAlert = false
    @StateObject var dataModel = DataModel()
    //screensize width = 393
    //screensize height = 852
    //aspectratio
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                StarBackground()
                
                VStack(spacing: 40){
                    
                    Spacer()
                        .frame(height: 150)
                    
                    Logo {
                        withAnimation(.easeInOut(duration: 1)) {
                            showButton = true
                        }
                    }
                    
                    //                Image("logo")
                    //                    .resizable()
                    //                    .scaledToFit()
                    //                    .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.24)
                    
                    Spacer()
                        .frame(height: screenSize.height * 0.1)
                    
                    if showButton{
                        Button(action: {
                            checkCameraPermissionAndNavigate()
                        }) {
                            ButtonView(primaryColor: .secondary200, secondaryColor: .secondary400, cornerRadius: 16)
                                .environmentObject(dataModel)
                                .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.06)
                                .overlay{
                                    HStack{
                                        Text("COMEÇAR AGORA")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.system(size: 14))
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.neutral800)
                                }
                        }
                    }
                    
                    
                }
            }
            .navigationDestination(isPresented: $navigateToConstellation) {
                ConstellationView(card: dataModel.cardsList[0])
            }
        }
        .background(
            EllipticalGradient(
                stops: [
                    Gradient.Stop(color: .primary600, location: 0.00),
                    Gradient.Stop(color: .primary900, location: 1.00),
                ],
                center: UnitPoint(x: 0.53, y: 0.5)
            )
        )
        .alert("Permissão de Câmera Necessária", isPresented: $showPermissionAlert) {
            Button("Abrir Configurações") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Para usar o AR, é necessário permitir o acesso à câmera. Vá em Configurações > Kuruxu > Câmera e ative a permissão.")
        }
    }
    
    private func checkCameraPermissionAndNavigate() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            navigateToConstellation = true
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        navigateToConstellation = true
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
            
        case .denied, .restricted:
            showPermissionAlert = true
            
        @unknown default:
            showPermissionAlert = true
        }
    }
}

#Preview() {
    StartView()
}
