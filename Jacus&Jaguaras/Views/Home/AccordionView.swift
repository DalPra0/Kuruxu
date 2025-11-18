////
////  AccordionView.swift
////  Jacus&Jaguaras
////
////  Created by Carla Araujo on 12/11/25.
////
//
//import SwiftUI
//
//struct AccordionView: View{
//    @State private var revealDetails = false
//    let card: CardModel
//    
//    var body: some View {
//        Form{
//            VStack{
//                    Image(card.imageName)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 225, height: 160)
//                            .cornerRadius(8)
//                            .padding(.horizontal, 20)
//                            .padding(.top, 14)
//                DisclosureGroup(card.title, isExpanded: $revealDetails) {
//                    Text(card.text)
//                    }
//                    .padding(8)
//            }
//           
//        }
//    }
//}
//
//#Preview() {
//    AccordionView(card:         CardModel(
//        imageName: "star01",
//        icon: "anta",
//        title: "Anta do Norte",
//        text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea.",
//        isActive: true
//    ))
//}
