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
    
    @State var tips = TipGroup(.ordered) {
        tip1()
        tip2()
    }
    
    var body: some View {
        ZStack(alignment: .top){
           ARTestView()
           TipView(tips.currentTip)
                .padding()
                .tipBackground(.primary900)
                .tint(.white)
       }
       .navigationBarBackButtonHidden(true)
    }
}

#Preview() {
    CameraView()
}
