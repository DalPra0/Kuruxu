//
//  LevelSelectionView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI


struct StartView: View {
    let screenSize = UIScreen.main.bounds
    @State private var showButton = false
    //screensize width = 393
    //screensize height = 852
    //aspectratio
    
    var body: some View {
        
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
                    NavigationLink(destination: ConstellationView(card: CardModel(
                        imageName: "star03",
                        icon: "lock.fill",
                        title: "Homem Velho",
                        text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida.",
                        isActive: false,
                        colorStroke: .primary600,
                        colorCircle: .primary400,
                        colorIcon: .primary600
                    ))){
                        ButtonView(primaryColor: .secondary200, secondaryColor: .secondary400, cornerRadius: 16)
                            .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.06)
                            .overlay{
                                HStack{                            Text("COMEÇAR AGORA")
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
        .background(
            EllipticalGradient(
                stops: [
                    Gradient.Stop(color: .primary600, location: 0.00),
                    Gradient.Stop(color: .primary900, location: 1.00),
                ],
                center: UnitPoint(x: 0.53, y: 0.5)
            )
        )
    }
}

#Preview() {
    StartView()
}
