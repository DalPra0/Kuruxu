//
//  ARTestView.swift
//  Jacus&Jaguaras
//
//  Created by Lucas Dal Pra Brascher on 10/11/25.
//

import SwiftUI

struct ARTestView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ARTestViewController {
        return ARTestViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARTestViewController, context: Context) {
    }
}
