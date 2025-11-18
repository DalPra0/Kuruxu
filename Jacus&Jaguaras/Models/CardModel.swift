//
//  CardModel.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 12/11/25.
//

import Foundation
import SwiftUI

struct DataModel{
    let cardsList: [CardModel] = [
        CardModel(
            imageName: "star01",
            icon: "anta",
            title: "Anta do Norte",
            text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea.",
            isActive: true,
            colorStroke: .purple500,
            colorCircle: .purple700,
            colorIcon: .white
        ),
        CardModel(
            imageName: "star02",
            icon: "lock.fill",
            title: "Ema",
            text: "A constelação da Ema simboliza a grande ave que corre pelos céus, marcando o início do tempo da colheita e ensinando sobre coragem e renovação.",
            isActive: false,
            colorStroke: .orange400,
            colorCircle: .orange200,
            colorIcon: .orange400
        ),
        CardModel(
            imageName: "star03",
            icon: "lock.fill",
            title: "Homem Velho",
            text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida.",
            isActive: false,
            colorStroke: .primary600,
            colorCircle: .primary400,
            colorIcon: .primary600
        ),
        CardModel(
            imageName: "star04",
            icon: "lock.fill",
            title: "Cervo",
            text: "A constelação do Cervo representa a força e a leveza da natureza, guiando os caçadores e ensinando o equilíbrio entre respeito e sobrevivência.",
            isActive: false,
            colorStroke: .secondary400,
            colorCircle: .secondary1001,
            colorIcon: .secondary400
        ),
    ]
}


struct CardModel: Identifiable {
    var id = UUID()
    var imageName: String
    var icon: String
    var title: String
    var text: String
    var isActive: Bool
    var colorStroke: Color
    var colorCircle: Color
    var colorIcon: Color
}
