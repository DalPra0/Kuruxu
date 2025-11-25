//
//  ConstellationView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import SwiftUI

struct ConstellationView: View {
    let screenSize = UIScreen.main.bounds
    let dataModel = DataModel()
    let card: CardModel
    @State var currentIndex = 0
    @State private var visible = false
    @State private var showPopup = false
    @EnvironmentObject var data: DataModel
    
    //screensize width = 393
    //screensize height = 852
    
    var body: some View {
        ZStack{
            StarBackground()
            
            VStack{
                ButtonView(primaryColor: dataModel.cardsList[currentIndex].colorStroke, secondaryColor: dataModel.cardsList[currentIndex].colorCircle, cornerRadius: 16)
                    .frame(width: screenSize.width * 0.85, height: screenSize.height * 0.1)
                    .overlay{
                        VStack(alignment: .leading, spacing: 8){
                            Text("CONSTELAÇÃO 0" + "\(currentIndex + 1), " + dataModel.cardsList[currentIndex].title)
                                .textCase(.uppercase)
                                .font(.system(size: 14))
                                .fontWeight(.heavy)
                            Text("Clique no ícone para montar\na constelação!")
                                .font(.system(size: 15))
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 12)
                        .foregroundStyle(.white)
                    }
                    .padding(.bottom, 48)
                    .opacity(visible ? 1 : 0)
                    .animation(.easeInOut(duration: 2.0), value: visible)
                
                VStack{
                    // MARK: ANTA
                    HStack{
                        Button{
                            //showPopup.toggle()
                            showPopup = true
                        }label:{
                            StarView(card: dataModel.cardsList[currentIndex],
                                     isActive: true)
                        }
                        Spacer()
                    }
                    
                    // MARK: CONSTELLATION 02
                    HStack{
                        Spacer()
                        StarView(card: dataModel.cardsList[currentIndex + 1],
                                 isActive: false)
                    }
                    .offset(x: 0, y: -20)
                    
                    // MARK: CONSTELLATION 03
                    HStack{
                        StarView(card: dataModel.cardsList[currentIndex + 2],
                                 isActive: false)
                        Spacer()
                    }
                    .offset(x: 0, y: -40)
                    
                    // MARK: CONSTELLATION 04
                    HStack{
                        Spacer()
                        StarView(card: dataModel.cardsList[currentIndex + 3],
                                 isActive: false)
                    }
                    .offset(x: 0, y: -60)
                }
            }
            .padding(.horizontal, 34)
            
            ConstellationPopUp(card: dataModel.cardsList[currentIndex])
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.background(.black.opacity(0.3))
                .background{
                    Rectangle()
                        .fill(.black.opacity(0.4))
                        .onTapGesture {
                            if showPopup {showPopup = false}
                        }
                }
                .opacity(showPopup ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: showPopup)
                .offset(y: -abs(screenSize.height * 0.07))
        }
        .onAppear {
            DispatchQueue.main.async {
                visible = true
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
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    ConstellationView(card: CardModel(
        imageName: "star03",
        icon: "lock.fill",
        title: "Homem Velho",
        text: "A constelação do Homem Velho retrata o sábio ancestral que observa o céu, lembrando os povos de honrar o tempo, a memória e o ciclo da vida.",
        isActive: false,
        colorStroke: .primary600,
        colorCircle: .primary400,
        colorIcon: .primary600
    ))
}
