//
//  EndingView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct EndingView: View {
    
    let card: CardModel
    
    var imageName: String = ""
    
    var body: some View {
        
        HStack{
            VStack(alignment: .leading, spacing: 24){
                VStack(alignment: .leading, spacing: 4){
                    Text(card.title)
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                    
                    Text("Constelação")
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.title2)
                        .bold()
                }
                
                Text(card.text)
                    .foregroundStyle(.white)
                    .font(.system(size: 15))
                    .frame(maxWidth: 267, maxHeight: 169)
                    .multilineTextAlignment(.leading)
                
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
                    Text("Voltar a tela inicial")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.4))
                        .cornerRadius(18)
                }
            }
            .padding(.horizontal, 32)
            .frame(width: 393)
            .frame(maxHeight: .infinity)
            .background(.white.opacity(0.1))
            
            Rectangle()
                .fill(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(.black)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview() {
    EndingView(card: CardModel(
                    imageName: "star01",
                    icon: "anta",
                    title: "Anta do Norte",
                    text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea.",
                    isActive: true,
                    colorStroke: .purple500,
                    colorCircle: .purple700,
                    colorIcon: .white
                ))
}
