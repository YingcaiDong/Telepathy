//
//  CellBehaviorController.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-03-26.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit

class CellBehaviorController: UICollectionViewLayout {
    fileprivate var frameHeight: CGFloat = 0
    fileprivate var frameWidth: CGFloat = 0
    fileprivate let inset: CGFloat = 15
    fileprivate let foot_height: CGFloat = 50
    fileprivate var attributesCollection = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        frameHeight = collectionView!.frame.height
        frameWidth = collectionView!.frame.width
        
        let itemsPerRow: CGFloat = 5
        var itemsPerCol: CGFloat = 10
        var cellSize: CGSize
        var xOffSet = [CGFloat]()
        var yOffSet = [CGFloat]()
        
        if collectionView!.numberOfItems(inSection: 0) == 37 {
            itemsPerCol = 8
            
            let insetsWide = inset * (itemsPerCol + 1)
            let insetsHeight = inset * itemsPerRow
            cellSize = CGSize(width: (frameWidth - insetsWide) / itemsPerCol, height: (frameHeight - insetsHeight - foot_height) / itemsPerRow)
            
            for cols in 0 ..< Int(itemsPerCol) {
                xOffSet.append(CGFloat(cols + 1) * (inset + (0.5 * cellSize.width)) + (CGFloat(cols) * 0.5 * cellSize.width))
            }
            for rows in 0 ..< Int(itemsPerRow) {
                yOffSet.append(CGFloat(rows + 1) * (inset + (0.5 * cellSize.height)) + (CGFloat(rows) * 0.5 * cellSize.height))
            }
        }
        else if collectionView!.numberOfItems(inSection: 0) > 37 {
            let insetsWide = inset * (itemsPerCol + 1)
            let insetsHeight = inset * itemsPerRow
            cellSize = CGSize(width: (frameWidth - insetsWide) / itemsPerCol, height: (frameHeight - insetsHeight - foot_height) / itemsPerRow)
            
            for cols in 0 ..< Int(itemsPerCol) {
                xOffSet.append(CGFloat(cols + 1) * inset + (CGFloat(cols) * cellSize.width))
            }
            for rows in 0 ..< Int(itemsPerRow) {
                yOffSet.append(CGFloat(rows + 1) * inset + (CGFloat(rows) * cellSize.height))
            }
        } else {
            cellSize = CGSize(width: 100, height: 100)
            xOffSet.append(inset + (0.5 * cellSize.width))
            yOffSet.append(inset + (0.5 * cellSize.height))
        }
        
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let perCol = item % Int(itemsPerCol)
            let perRow = Int(item / Int(itemsPerCol))
            let cellFrame = CGRect(x: xOffSet[perCol], y: yOffSet[perRow], width: cellSize.width, height: cellSize.height)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            attributesCollection.append(attributes)
        }
        
        self.collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "SeparatorViewKind", withReuseIdentifier: "footbutton")
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: frameWidth, height: frameHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let foot_view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footbutton", for: indexPath)
        foot_view.backgroundColor = UIColor.white
        
        let foot_attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        foot_attributes.frame = CGRect(x: 0, y: frameHeight - foot_height, width: frameWidth, height: foot_height)
        attributesCollection.append(foot_attributes)
        
        return foot_view
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in attributesCollection {
            if rect.intersects(attributes.frame) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var result: UICollectionViewLayoutAttributes?
        for attributes in attributesCollection {
            if attributes.indexPath == indexPath {
                result = attributes
            } else {
                result = nil
            }
        }
        return result
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var result: UICollectionViewLayoutAttributes?
        for attributes in attributesCollection {
            if indexPath == attributes.indexPath {
                result = attributes
            } else {
                result = nil
            }
        }
        return result
    }
}

extension CellBehaviorController {

}

extension CellBehaviorController {
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: itemIndexPath)!
        
        attributes.alpha = 0.0
        
        let size: CGSize = CGSize(width: frameWidth, height: frameHeight)
        attributes.center = CGPoint(x: size.width / 2, y: size.height / 2)
        return attributes
    }
    
    override func finalizeCollectionViewUpdates() {
    }
    
}
