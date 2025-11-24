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
        Text("Marque uma estrela")
    }
    
    var message: Text? {
        Text("Aponte a câmera para uma carta e leia a primeira estrela da constelação. É imporante que o lado com o mosaico esteja para cima.")
            .foregroundStyle(.purple400)
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
        Text("Complete com o restante das cartas até a constelação aparecer, posicionando corretamente de acordo com a numeração da estrela.")
            .foregroundStyle(.purple400)
    }
    
    var image: Image? {
        Image(systemName: "sparkles")
    }

    var actions: [Action] {
        Action(id: "finalizar") {
            invalidate(reason: .tipClosed)
        } _: {
            if #available(iOS 26, *) {
                Text("Vamos Lá!")
                    .foregroundStyle(.primary900)
            } else {
                Text("Vamos Lá!")
                    .foregroundStyle(.secondary200)
            }
        }
    }
}
