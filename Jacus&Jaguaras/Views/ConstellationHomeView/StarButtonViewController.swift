//
//  StarButtonViewController.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import UIKit

class StarButtonViewController: UIViewController {
    
    private let starButtonView: StarButtonView
    private let star: CardModel
    
    init(star: CardModel){
        self.star = star
        starButtonView = StarButtonView(star: star)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = starButtonView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
