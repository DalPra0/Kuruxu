//
//  ContentView.swift
//  Jacus&Jaguaras
//
//  Created by Lucas Dal Pra Brascher on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showARTest = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {

                Text("Teste AR Marker")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                    .frame(height: 50)
                
                Button(action: {
                    showARTest = true
                }) {
                    HStack {
                        Text("Iniciar Teste AR")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: 280)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text("1")
                            .font(.title2)
                        Text("Imprima o marker em papel A4")
                            .font(.system(size: 14))
                    }
                    
                    HStack(alignment: .top) {
                        Text("2")
                            .font(.title2)
                        Text("Coloque em uma superfície plana")
                            .font(.system(size: 14))
                    }
                    
                    HStack(alignment: .top) {
                        Text("3")
                            .font(.title2)
                        Text("Aponte a câmera para o marker")
                            .font(.system(size: 14))
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $showARTest) {
            ARTestView()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
