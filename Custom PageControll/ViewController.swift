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
    
    private var indicatorViews = [UIView]()
    private var currentSlide = 0 //для индикации шейпа кнопки next
    private var startProgressIndex = 0.0
    
    private let shape = CAShapeLayer()
    private let animation = CABasicAnimation(keyPath: "strokeEnd")
    
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
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return btn
    }()
    
    lazy var nextBtn: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextSlide))
        let nextImg = UIImageView()
        nextImg.image = UIImage(systemName: "chevron.right.circle.fill")
        nextImg.tintColor = .white
        nextImg.contentMode = .scaleAspectFit
        nextImg.translatesAutoresizingMaskIntoConstraints = false
        nextImg.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nextImg.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        let btn = UIView()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(tapGesture)
        btn.addSubview(nextImg)
        
        nextImg.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
        nextImg.centerXAnchor.constraint(equalTo: btn.centerXAnchor).isActive = true
        return btn
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
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
        setShapeLayer()
    }
    
    @objc func toSlide(sender: UIGestureRecognizer) {
        //UIGestureRecognizer умеет хранить в себе вью на которое нажали. Достаем оттуда тег
        if let selectedViewTag = sender.view?.tag {
            sliderCollectionView.scrollToItem(at: IndexPath(item: selectedViewTag, section: 0), at: .centeredHorizontally, animated: true)
            
            self.currentSlide = selectedViewTag //записываем в переменную тег выделенной вью. Нужно для анимации шейпа кнопки
        }
    }
    
    @objc func nextSlide() {
        let maxSlide = sliderData.count - 1 //чтобы не выйти за пределы массива при скролле ячеек
        
        if currentSlide < maxSlide {
            sliderCollectionView.scrollToItem(at: IndexPath(item: currentSlide + 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    private func configurePageControl() {
        view.addSubview(hStack)
        
        let indicatorStack = UIStackView()
        indicatorStack.axis = .horizontal
        indicatorStack.alignment = .center
        indicatorStack.distribution = .fill
        indicatorStack.spacing = 5
        indicatorStack.translatesAutoresizingMaskIntoConstraints = false
        
        for tag in 0...sliderData.count - 1 {
            let tagView = UIView()
            tagView.tag = tag
            tagView.backgroundColor = .white
            tagView.translatesAutoresizingMaskIntoConstraints = false
            tagView.layer.cornerRadius = 5
            tagView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toSlide)))
            self.indicatorViews.append(tagView)
            indicatorStack.addArrangedSubview(tagView)
        }
        
        vStack.addArrangedSubview(indicatorStack)
        vStack.addArrangedSubview(skipBtn)
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(nextBtn)
        
        hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setShapeLayer() {
        let point = UIBezierPath(arcCenter: CGPoint(x: 25, y: 25), radius: 23, startAngle: -(.pi/2), endAngle: 5, clockwise: true)
        
        shape.path = point.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.lineCap = .round
        shape.strokeStart = 0.0
        shape.strokeEnd = 0.0
        
        nextBtn.layer.addSublayer(shape)
    }
    
    private func setBasicAnimation(from valueA: CGFloat, to valueB: CGFloat) {
        animation.fromValue = valueA
        animation.toValue = valueB
        animation.isRemovedOnCompletion = false //не удалять после анимации
        animation.fillMode = .forwards
        animation.duration = 0.5
        shape.add(animation, forKey: nil)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentSlide = indexPath.item //каждый раз определяем текущий слайд по индексу отображаемой ячейки, для индикатора
        
        //если тег view совпал с индексом cell то он будет выделяться
        indicatorViews.forEach { view in
            let tag = view.tag //нужен для сравнения тегов
            //Хак: при каждом новом отображении ячейки будут обнуляться старые констрейнты и выставляться новые в зависимости от условия if ниже
            view.constraints.forEach { constr in
                view.removeConstraint(constr)
            }
            
            if indexPath.item == tag {
                view.layer.opacity = 1
                view.widthAnchor.constraint(equalToConstant: 20).isActive = true
            } else {
                view.layer.opacity = 0.5
                view.widthAnchor.constraint(equalToConstant: 10).isActive = true
            }
            
            view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
        
        //Логика анимации прогресса
        let progressIndex = CGFloat(1) / CGFloat(sliderData.count) * CGFloat(indexPath.item + 1) //index for indicator progress
        setBasicAnimation(from: startProgressIndex, to: progressIndex)
        startProgressIndex = progressIndex
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

