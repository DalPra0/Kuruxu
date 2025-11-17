//
//  StarButtonView.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 17/11/25.
//

import UIKit
import SnapKit

class StarButtonView: UIView {
    private(set) lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private(set) lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        addSubview(background)
        addSubview(image)
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { (make) in
            make.center.equalTo(background)
        }
        
        background.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
