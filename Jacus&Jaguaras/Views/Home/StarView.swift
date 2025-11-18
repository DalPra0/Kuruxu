//
//  StarView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 18/11/25.
//

import SwiftUI


//struct Line: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: rect.width, y: 0))
//        return path
//    }
//}


struct StarView: View {
    
    let dataModel = DataModel()
    let card: CardModel
    
    var isActive: Bool
    
    var body: some View {
        
        ZStack {
            
            if isActive{
                
                Circle()
                    .stroke(.primary400,
                            style: StrokeStyle(lineWidth: 2,
                                               dash: [10, 20]))
                    .frame(width: 163, height: 163)
                
                Circle()
                    .fill(card.colorCircle)
                    .stroke(card.colorStroke, lineWidth: 12)
                    .frame(width: 133, height: 133)
                
                
                
                Image(card.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 89, height: 59)
            } else {
                
                Circle()
                    .fill(card.colorCircle)
                    .stroke(card.colorStroke, lineWidth: 12)
                    .frame(width: 133, height: 133)
                
                Image(systemName: card.icon)
                    .foregroundStyle(card.colorIcon)
                    .font(.system(size: 80))
                    .frame(width: 89, height: 59)
            }
            
        }
        
    }
}

#Preview {
    StarView(card: CardModel(
        imageName: "star03",
        icon: "lock.fill",
        title: "Homem Velho",
        text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida.",
        isActive: false,
        colorStroke: .primary600,
        colorCircle: .primary400,
        colorIcon: .primary600
    ), isActive: false)
}
