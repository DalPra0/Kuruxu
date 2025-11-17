//
//  NavigationConstellation.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import SwiftUI

struct NavigationConstellationView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ConstellationViewController {
        return ConstellationViewController()
    }
    
    func updateUIViewController(_ uiViewController: ConstellationViewController, context: Context) {
    }
}
