//
//  HomeView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    @State var currentIndex = 0
    @State var activeCard: CardModel?
    let dataModel = DataModel()
    var body: some View {
        
        HStack{
            // MARK: VOLTAR
            if currentIndex >= 1{
                Button{
                    if currentIndex > 0 {
                        currentIndex -= 2
                    }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
            } else {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.gray)
            }
            
            HStack{
                NavigationLink(destination: EndingView(card: dataModel.cardsList[currentIndex])) {
                    AccordionView(card: dataModel.cardsList[currentIndex])
                }
                NavigationLink(destination: EndingView(card: dataModel.cardsList[currentIndex])){
                    AccordionView(card: dataModel.cardsList[currentIndex + 1])
                }
            }
            .transition(.move(edge: .leading))
            .animation(.easeInOut(duration: 0.5), value: currentIndex)
            
            // MARK: PROXIMO
            if currentIndex < dataModel.cardsList.count - 2 {
                Button {
                    currentIndex += 2
                } label: {
                    Image(systemName: "chevron.right")
                }
            } else {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            
        }
    }
    
}

#Preview(traits: .landscapeLeft) {
    HomeView()
}
