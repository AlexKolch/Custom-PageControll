//
//  ViewController.swift
//  Custom PageControll
//
//  Created by Алексей Колыченков on 25.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let sliderData: [SliderItem] = [
    SliderItem(color: "#0E0F54", title: "Slide 1",
               text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",
               animationName: "Animation1"),
    SliderItem(color: "#778beb", title: "Slide 2",
               text: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
               animationName: "Animation2"),
    SliderItem(color: "#351458", title: "Slide 3",
               text: "dolore magna aliqua. Ut enim ad minim veniam",
               animationName: "Animation3")
    ]
    
    private var tagViews = [UIView]()
    
    lazy var sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(SliderCell.self, forCellWithReuseIdentifier: "cell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    lazy var skipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sliderCollectionView)
        configurePageControl()
        setLayout()
    }

    private func configurePageControl() {
        view.addSubview(hStack)
        
        let indicatorStack = UIStackView()
        indicatorStack.axis = .horizontal
        indicatorStack.alignment = .center
        indicatorStack.distribution = .fill
        indicatorStack.spacing = 5
        indicatorStack.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in 1...sliderData.count {
            let tagView = UIView()
            tagView.tag = tag
            tagView.backgroundColor = .white
            tagView.translatesAutoresizingMaskIntoConstraints = false
            tagView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            tagView.widthAnchor.constraint(equalToConstant: 10).isActive = true
            tagView.layer.cornerRadius = 5
            self.tagViews.append(tagView)
            indicatorStack.addArrangedSubview(tagView)
        }
        vStack.addArrangedSubview(indicatorStack)
        vStack.addArrangedSubview(skipBtn)
        hStack.addArrangedSubview(vStack)
        
        hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sliderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SliderCell else {
            return UICollectionViewCell()
        }
        let item = sliderData[indexPath.item]
        cell.contentView.backgroundColor = UIColor(hexaRGBA: item.color)
        cell.configureCell(title: item.title, text: item.text)
        cell.setupAnimation(name: item.animationName)
        return cell
    }
    
    
}

private extension ViewController {
    func setLayout() {
        NSLayoutConstraint.activate([
            sliderCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            sliderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sliderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sliderCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

