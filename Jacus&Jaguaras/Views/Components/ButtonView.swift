//
//  ButtonView.swift
//  Jacus&Jaguaras
//
//  Created by Crisspy on 18/11/25.
//

import SwiftUI

struct ButtonView: View {
    
    let primaryColor: Color
    let secondaryColor: Color
    let cornerRadius: CGFloat
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(secondaryColor)
                .offset(y: 5)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(primaryColor)
        }
    }
}
