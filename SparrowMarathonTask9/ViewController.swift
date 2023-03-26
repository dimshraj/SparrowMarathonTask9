//
//  ViewController.swift
//  SparrowMarathonTask9
//
//  Created by Dmitriy Shrayber on 26.03.2023.
//

import UIKit
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private let cellIdentifier = "CustomCell"
    private let cellWidth: CGFloat = 250
    private let cellHeight: CGFloat = 400
    private let numberOfItems: Int = 10

    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: cellWidth
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        self.title = "Collection"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        )
        cell.backgroundColor = .systemBlue
        cell.layer.cornerRadius = 8
        return cell
    }
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let cellWidth: CGFloat = 250
    let cellHeight: CGFloat = 400
    let spacing: CGFloat = 8
    let layoutMargins = CGFloat(16)
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        itemSize = CGSize(width: cellWidth, height: cellHeight)
        minimumLineSpacing = spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(
                forProposedContentOffset: proposedContentOffset,
                withScrollingVelocity: velocity
            )
        }
        
        let targetRect = CGRect(
            x: proposedContentOffset.x,
            y: 0,
            width: collectionView.bounds.width,
            height: collectionView.bounds.height
        )
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + layoutMargins
        
        if let layoutAttributesArray = layoutAttributesForElements(in: targetRect) {
            for layoutAttributes in layoutAttributesArray {
                let itemOffset = layoutAttributes.frame.origin.x
                if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                    offsetAdjustment = itemOffset - horizontalOffset
                }
            }
        }
        
        return CGPoint(
            x: proposedContentOffset.x + offsetAdjustment,
            y: proposedContentOffset.y
        )
    }
}

