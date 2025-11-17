//
//  CameraView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI

struct CameraView: View {
    
    let dataModel = DataModel()
    
    var body: some View {
       ZStack{
           ARTestView()
           NavigationLink(destination: EndingView(card: dataModel.cardsList[0])){
               Text("OK")
                   .font(.title)
                   .foregroundStyle(.white)
                   .padding()
                   .background(.black.opacity(0.7))
           }
       }
    }
}

#Preview() {
    CameraView()
}
