//
//  Logo.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 18/11/25.
//

import SwiftUI

struct Logo: View {
    let images = ["logo01", "logo02", "logo03", "logo04", "logo05", "logo06", "logo"]
    @State private var index = 0
    let screenSize = UIScreen.main.bounds
    var onFinish: (() -> Void)?
    
    var body: some View {
        ZStack {
            ForEach(images.indices, id: \.self) { i in
                Image(images[i])
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenSize.width * 0.5,
                           height: screenSize.height * 0.24)
                    .opacity(i == index ? 1 : 0)
                    .animation(.easeInOut(duration: 1.5), value: index)
            }
        }
        .onAppear {
            var timer: Timer? = nil
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { t in
                if index < images.count - 1 {
                    index += 1
                } else {
                    timer?.invalidate()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        onFinish?()
                    }
                }
            }
        }
    }
}
