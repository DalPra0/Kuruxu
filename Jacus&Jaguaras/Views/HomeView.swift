//
//  HomeView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        
        VStack(spacing: 40){
            
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(uiColor: .systemGray4))
                .frame(width: 229, height: 88)
                .overlay{
                    Text("Logo")
                        .font(.system(size: 40))
                        .foregroundStyle(.black)
                }
            
            Button(){
                
            }label: {
                
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(uiColor: .systemGray4))
                    .frame(width: 161, height: 69)
                    .overlay{
                        Text("Começar")
                            .font(.system(size: 24))
                            .foregroundStyle(.black)
                    }
            }
        }
    }
}

#Preview(traits: .landscapeLeft) {
    HomeView()
}
