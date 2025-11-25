//
//  ConstellationPopUp.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 24/11/25.
//

import SwiftUI

struct ConstellationPopUp: View {
    
    let card: CardModel
    let desc = "A constelação com mais estrelas, com certeza é um desafio e tanto!"
    let dataModel = DataModel()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(card.colorStroke)
            .frame(width: screenSize.width * 0.65, height: screenSize.height * 0.17)
            .overlay{
                VStack (spacing: 12){
                    
                    Text(card.title)
                        .foregroundStyle(.white)
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Text(desc)
                        .foregroundStyle(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    
                    NavigationLink(destination: CameraView().environmentObject(dataModel)){
                        ButtonView(primaryColor: .white, secondaryColor: card.colorCircle, cornerRadius: 12)
                            .frame(width: screenSize.width * 0.46, height: screenSize.height * 0.046)
                            .shadow(radius: 2)
                            .overlay{
                                Text("JOGAR AGORA")
                                .font(.system(size: 11))
                                .fontWeight(.heavy)
                                .foregroundStyle(card.colorCircle)
                            }
                    }
                }
            }
    }
}
