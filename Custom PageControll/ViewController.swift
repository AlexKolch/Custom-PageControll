//
//  ViewController.swift
//  Custom PageControll
//
//  Created by Алексей Колыченков on 25.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private let sliderData: [SliderItem] = [
    SliderItem(color: "#f19066", title: "Slide 1",
               text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod",
               animationName: ""),
    SliderItem(color: "#778beb", title: "Slide 2",
               text: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
               animationName: ""),
    SliderItem(color: "#34ace0", title: "Slide 3",
               text: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam",
               animationName: "")
    ]
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(sliderCollectionView)
        setLayout()
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

