//
//  LevelSelectionView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack{
            
            Image("starBackground")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: 40){
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 297, height: 125)
                
                NavigationLink(destination: HomeView()){
                    RoundedRectangle(cornerRadius: 64)
                        .fill(Color(uiColor: .secondary400))
                        .frame(width: 244, height: 49)
                        .overlay{
                            Text("Começar")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary600)
                        }
                }
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.primary900, .primary600]), startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview(traits: .landscapeLeft) {
    StartView()
}
