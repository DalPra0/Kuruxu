//
//  FinalView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 19/11/25.
//

import SwiftUI

struct FinalView: View {
    
    let card: CardModel
    let dataModel = DataModel()
    @State var currentIndex = 0
    let screenSize = UIScreen.main.bounds
    @EnvironmentObject var data: DataModel
    
    let lastPhotoData = SavedPhotosManager.shared.getPhotos().last
    
    //screensize width = 393
    //screensize height = 852
    
    var body: some View {
        VStack(spacing: 48){
            Image(dataModel.cardsList[currentIndex].imageName)
                .resizable()
                .scaledToFit()
                .frame(width: screenSize.width * 0.9, height: screenSize.height * 0.24)
            
            VStack(alignment: .leading, spacing: 16){
                VStack(alignment: .leading, spacing: 8){
                    Text(dataModel.cardsList[currentIndex].title)
                        .font(.largeTitle)
                        .foregroundStyle(.neutral50)
                        .fontWeight(.bold)
                    Text("Constelação")
                        .font(.title2)
                        .foregroundStyle(.neutral50)
                }
                Text(dataModel.cardsList[currentIndex].text)
                    .font(.system(size: 15))
                    .foregroundStyle(.neutral50)
            }
            
            VStack{
                NavigationLink(destination: ConstellationView(card: dataModel.cardsList[0])
                    .environmentObject(dataModel)
                ){                ButtonView(primaryColor: .neutral50, secondaryColor: .primary400, cornerRadius: 16)
                        .frame(width: screenSize.width * 0.88, height: screenSize.height * 0.06)
                        .overlay{
                            HStack{
                                Text("RETORNAR AO INÍCIO")
                                Image(systemName: "house")
                            }
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.primary900)
                            
                        }}
                
                //                ForEach(SavedPhotosManager.shared.getPhotos(), id: \.self) { photoData in
                //                    Image(uiImage: UIImage(data: photoData)!)
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: screenSize.width * 0.45, height: screenSize.height * 0.24)
                //                }
                
            }
            
            
        }
        .background(
            ZStack{
                
                Image(uiImage: UIImage(data: lastPhotoData!)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenSize.width, height: screenSize.height)
                Color(.black)
                    .opacity(0.8)
            }
            
        )
    }
}

#Preview {
    FinalView(card:
                CardModel(
                    imageName: "antaConstelacao",
                    icon: "anta",
                    title: "Anta do Norte",
                    text: "A constelação da Anta do Norte representa o espírito guardião das águas, que guia os rios e protege as florestas sob o brilho da Via Láctea.",
                    isActive: true,
                    colorStroke: .purple500,
                    colorCircle: .purple700,
                    colorIcon: .white
                ))
}
