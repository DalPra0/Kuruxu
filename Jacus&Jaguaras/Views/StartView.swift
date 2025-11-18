//
//  LevelSelectionView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct StartView: View {
    let screenSize = UIScreen.main.bounds
    //screensize width = 393
    //screensize height = 852
    //aspectratio
    
    var body: some View {
        
        ZStack{
            Image("starBackground")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: 40){
                
                Spacer()
                    .frame(height: 150)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenSize.width * 0.5, height: screenSize.height * 0.24)
                
                Spacer()
                    .frame(height: screenSize.height * 0.1)
                
                NavigationLink(destination: ConstellationView()){
                    ButtonView(primaryColor: .secondary200, secondaryColor: .secondary400, cornerRadius: 16)
                        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.06)
                    .overlay{
                        HStack{                            Text("COMEÇAR AGORA")
                            Image(systemName: "chevron.right")
                        }
                        .font(.system(size: 14))
                        .fontWeight(.heavy)
                        .foregroundStyle(.neutral800)
                    }
                }
            }
        }
        .background(
            EllipticalGradient(
            stops: [
                Gradient.Stop(color: .primary600, location: 0.00),
            Gradient.Stop(color: .primary900, location: 1.00),
            ],
            center: UnitPoint(x: 0.53, y: 0.5)
            )
        )
    }
}

#Preview() {
    StartView()
}
