//
//  ConstellationView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import UIKit
import SnapKit

class ConstellationView: UIView {
    
    var onClicked: (() -> Void)?
    let screen = UIScreen.main.bounds
    
    private(set) lazy var star01: UIButton = {
        let star = UIButton()
        star.frame = CGRect(x: screen.width*0.3, y: 0, width: 60, height: 60)
        star.backgroundColor = .red
        let action = UIAction { _ in
            self.onClicked}
        star.addAction(action, for: .touchUpInside)
        return star
    }()
    
    private(set) lazy var star02: UIButton = {
        let star = UIButton()
        star.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        star.backgroundColor = .blue
        let action = UIAction { _ in
            self.onClicked}
        star.addAction(action, for: .touchUpInside)
        return star
    }()
    
    private(set) lazy var star03: UIButton = {
        let star = UIButton()
        star.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        star.backgroundColor = .green
        let action = UIAction { _ in
            self.onClicked}
        star.addAction(action, for: .touchUpInside)
        return star
    }()
    
    private(set) lazy var star04: UIButton = {
        let star = UIButton()
        star.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        star.backgroundColor = .black
        let action = UIAction { _ in
            self.onClicked}
        star.addAction(action, for: .touchUpInside)
        return star
    }()
    
    private(set) lazy var star05: UIButton = {
        let star = UIButton()
        star.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        star.backgroundColor = .purple
        let action = UIAction { _ in
            self.onClicked}
        star.addAction(action, for: .touchUpInside)
        return star
    }()
    
    // MARK: INITIALIZER
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    
    // MARK: SETUP
    private func addSubviews(){
        addSubview(star01)
        addSubview(star02)
        addSubview(star03)
        addSubview(star04)
        addSubview(star05)
    }
    
    private func setupConstraints(){
        star01.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        star02.snp.makeConstraints { (make) in
            make.top.equalTo(star01).inset(20)
        }
        star03.snp.makeConstraints { (make) in
            make.bottom.equalTo(star01).inset(20)
        }
        star04.snp.makeConstraints { (make) in
            make.leading.equalTo(star01).inset(20)
        }
        star05.snp.makeConstraints { (make) in
            make.trailing.equalTo(star01).inset(20)
        }
    }
    
    
    
}



