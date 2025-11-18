//
//  ConstellationView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import SwiftUI

struct ConstellationView: View {

    let dataModel = DataModel()
    @State var currentIndex = 0
    
    var body: some View {
        ZStack{
            Image("starBackground")
                .resizable()
                .scaledToFill()
            
            VStack{
                
                // MARK: ANTA
                HStack{
                    NavigationLink(destination: CameraView()){
                        StarView(card: dataModel.cardsList[currentIndex], isActive: true
                        )
                    }
                    Spacer()
                }
                
                // MARK: CONSTELLATION 02
                HStack{
                    Spacer()
                    StarView(card: dataModel.cardsList[currentIndex + 1], isActive: false
                    )
                }
                .offset(x: 0, y: -20)
                
                // MARK: CONSTELLATION 03
                HStack{
                    StarView(card: dataModel.cardsList[currentIndex + 2], isActive: false
                    )
                    Spacer()
                }
                .offset(x: 0, y: -40)
                
                // MARK: CONSTELLATION 04
                HStack{
                    Spacer()
                    StarView(card: dataModel.cardsList[currentIndex + 3], isActive: false
                    )
                }
                .offset(x: 0, y: -60)
                
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
