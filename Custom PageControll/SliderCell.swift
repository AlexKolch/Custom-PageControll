//
//  SliderCell.swift
//  Custom PageControll
//
//  Created by Алексей Колыченков on 25.06.2024.
//

import UIKit
import Lottie

class SliderCell: UICollectionViewCell {
    
   private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lottieView = LottieAnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(lottieView)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, text: String) {
        self.titleLabel.text = title
        self.textLabel.text = text
    }
    
    ///настройка lottie анимации
    func setupAnimation(name: String) {
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        lottieView.animation = LottieAnimation.named(name)
        lottieView.loopMode = .loop
        lottieView.contentMode = .scaleAspectFit
        lottieView.play()
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lottieView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lottieView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lottieView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
