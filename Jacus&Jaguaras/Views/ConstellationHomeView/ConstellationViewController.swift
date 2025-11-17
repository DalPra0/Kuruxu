//
//  ConstellationViewController.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import UIKit

class ConstellationViewController: UIViewController {
    
    let constellationView = ConstellationView()
    private var constellation: [CardModel] = CardModel.cardsList()
    
    override func loadView() {
        super.loadView( )
        self.view = constellationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func navigateToCameraView(){
        let ending
    }
}

