//
//  DataModel.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 12/11/25.
//

import Foundation

struct DataModel{
    let cardsList: [CardModel] = [
        CardModel(
            imageName: "star",
            title: "Anta do Norte",
            text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea."
        ),
        CardModel(
            imageName: "star",
            title: "Ema",
            text: "A constelação da Ema simboliza a grande ave que corre pelos céus, marcando o início do tempo da colheita e ensinando sobre coragem e renovação."
        ),
        CardModel(
            imageName: "star",
            title: "Homem Velho",
            text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida."
        ),
        CardModel(
            imageName: "star",
            title: "Cervo",
            text: "A constelação do Cervo representa a força e a leveza da natureza, guiando os caçadores e ensinando o equilíbrio entre respeito e sobrevivência."
        ),
    ]
}
