//
//  Tipkit.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 19/11/25.
//

import Foundation
import TipKit

struct tip1: Tip {
    
    static let readCardEvent = Event(id: "readCard")
    
    var title: Text {
        Text("Marque uma estrela")
    }
    
    var message: Text? {
        Text("Aponte a câmera para ler a primeira carta da constelação e marcar a estrela.")
            .foregroundStyle(.purple400)
    }
    
    var image: Image? {
        Image(systemName: "camera.fill")
    }
    
    var rules: [Rule] {
        #Rule(Self.readCardEvent) { event in
            event.donations.count == 0
        }
    }
}

struct tip2: Tip {
    var title: Text {
        Text("Monte a constelação")
    }
    
    var message: Text? {
        Text("Posicione todas as cartas e tente completar até a constelação aparecer.")
            .foregroundStyle(.purple400)
    }
    
    var image: Image? {
        Image(systemName: "sparkles")
    }

    var actions: [Action] {
        Action(id: "finalizar") {
            invalidate(reason: .tipClosed)
        } _: {
            Text("Vamos Lá!")
                .foregroundStyle(.secondary200)
        }
    }
}
