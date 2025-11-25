//
//  CameraView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 11/11/25.
//

import SwiftUI
import TipKit

struct CameraView: View {
    @EnvironmentObject var data: DataModel
    let dataModel = DataModel()
    @State private var navigateToFinal = false
    
    @State var tips = TipGroup(.ordered) {
        tip1()
        tip2()
    }
    
    var body: some View {
        ZStack(alignment: .top){
           ARTestView(onPhotoTaken: {
               navigateToFinal = true
           })
           TipView(tips.currentTip)
                .padding()
                .tipBackground(.primary900)
                .tint(.white)
       }
       .navigationDestination(isPresented: $navigateToFinal) {
           FinalView(card: dataModel.cardsList[0])
               .environmentObject(dataModel)
       }
       .navigationBarBackButtonHidden(true)
    }
}

#Preview() {
    CameraView()
}
