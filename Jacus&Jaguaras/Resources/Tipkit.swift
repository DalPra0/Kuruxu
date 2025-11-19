//
//  Tipkit.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 19/11/25.
//

import Foundation
import TipKit

struct tip1: Tip {
    var title: Text {
        Text("Marque a estrela")
    }
    
    var message: Text? {
        Text("Aponte a câmera para ler a primeira carta da constelação e marcar a estrela.")
            .foregroundStyle(.white)
    }
    
    var image: Image? {
        Image(systemName: "camera.fill")
    }
}

struct tip2: Tip {
    var title: Text {
        Text("Monte a constelação")
    }
    
    var message: Text? {
        Text("Posicione todas as cartas e tente completar até a constelação aparecer.")
            .foregroundStyle(.white)
    }
    
    var image: Image? {
        Image(systemName: "sparkles")
    }
}
