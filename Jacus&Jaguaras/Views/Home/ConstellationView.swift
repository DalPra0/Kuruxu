//
//  ConstellationView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import SwiftUI

struct ConstellationView: View {
    var body: some View {
        ZStack{
            Image("starBackground")
                .resizable()
                .scaledToFill()
            
            VStack{
                
                // MARK: ANTA
                HStack{
                    StarView(card: CardModel(
                        imageName: "star01",
                        icon: "anta",
                        title: "Anta do Norte",
                        text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea.",
                        isActive: true,
                        colorStroke: .purple500,
                        colorCircle: .purple700,
                        colorIcon: .white
                    ),
                             isActive: true)
                    Spacer()
                }
                
                // MARK: CONSTELLATION 02
                HStack{
                    Spacer()
                    StarView(card: CardModel(
                        imageName: "star02",
                        icon: "lock.fill",
                        title: "Ema",
                        text: "A constelação da Ema simboliza a grande ave que corre pelos céus, marcando o início do tempo da colheita e ensinando sobre coragem e renovação.",
                        isActive: false,
                        colorStroke: .orange400,
                        colorCircle: .orange200,
                        colorIcon: .orange400
                    ),
                             isActive: false)
                }
                .offset(x: 0, y: -20)
                
                // MARK: CONSTELLATION 03
                HStack{
                    StarView(card: CardModel(
                        imageName: "star03",
                        icon: "lock.fill",
                        title: "Homem Velho",
                        text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida.",
                        isActive: false,
                        colorStroke: .primary600,
                        colorCircle: .primary400,
                        colorIcon: .primary600
                    ),
                             isActive: false)
                    Spacer()
                }
                .offset(x: 0, y: -20)
                
                // MARK: CONSTELLATION 04
                HStack{
                    Spacer()
                    StarView(card: CardModel(
                        imageName: "star04",
                        icon: "lock.fill",
                        title: "Cervo",
                        text: "A constelação do Cervo representa a força e a leveza da natureza, guiando os caçadores e ensinando o equilíbrio entre respeito e sobrevivência.",
                        isActive: false,
                        colorStroke: .secondary400,
                        colorCircle: .secondary100,
                        colorIcon: .secondary400
                    ),
                             isActive: false)
                }
                .offset(x: 0, y: -20)
                
            }
            .padding(.horizontal, 34)
        }
        .background(
            Circle()
            .fill(
                RadialGradient(gradient: Gradient(colors: [.primary600, .primary900]), center: .center, startRadius: 10, endRadius: 300)
            )
            
            .frame(width: 1000, height: 1000)
        )
    }
}

#Preview {
    ConstellationView()
}
