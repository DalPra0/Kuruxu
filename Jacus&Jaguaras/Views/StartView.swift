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
                
                Spacer()
                    .frame(height: 150)
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 202.09, height: 203.05)
                
                Spacer()
                    .frame(height: 150)
                
                NavigationLink(destination: ConstellationView()){
                    ButtonView(primaryColor: .secondary200, secondaryColor: .secondary400, cornerRadius: 16)
                    .frame(width: 275, height: 49)
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
            LinearGradient(gradient: Gradient(colors: [.primary900, .primary600]), startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview() {
    StartView()
}
