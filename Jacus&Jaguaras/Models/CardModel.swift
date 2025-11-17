//
//  CardModel.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 12/11/25.
//

import Foundation

struct CardModel: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var text: String
}
