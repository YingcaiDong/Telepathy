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
    fileprivate var footIndex = IndexPath()
    
    fileprivate var allAttributes = NSMutableDictionary()
    fileprivate var cellAttributes = NSMutableDictionary()
    fileprivate var footerAttributes = NSMutableDictionary()
    
    override func prepare() {
        // MARK: - Clear previous caches
        allAttributes.removeAllObjects()
        cellAttributes.removeAllObjects()
        
        frameHeight = collectionView!.frame.height
        frameWidth = collectionView!.frame.width
        
        let itemsPerRow: CGFloat = 5
        var itemsPerCol: CGFloat = 10
        var cellSize: CGSize
        var xOffSet = [CGFloat]()
        var yOffSet = [CGFloat]()
        
        // MARK: Caculate each cells' frame information
        if collectionView!.numberOfItems(inSection: 0) == 37 {
            itemsPerCol = 8
            
            let insetsWide = inset * (itemsPerCol + 1)
            let insetsHeight = inset * itemsPerRow
            cellSize = CGSize(width: (frameWidth - insetsWide) / itemsPerCol, height: (frameHeight - insetsHeight - foot_height) / itemsPerRow)
            
            for cols in 0 ..< Int(itemsPerCol) {
                xOffSet.append(CGFloat(cols + 1) * inset + (CGFloat(cols) * cellSize.width))
            }
            for rows in 0 ..< Int(itemsPerRow) {
                yOffSet.append(CGFloat(rows + 1) * inset + (CGFloat(rows) * cellSize.height))
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
            xOffSet.append((frameWidth - cellSize.width) / 2)
            yOffSet.append((frameHeight - cellSize.height) / 2)
        }
        
        // MARK: - Set Cell attributes
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let perCol = item % Int(itemsPerCol)
            let perRow = Int(item / Int(itemsPerCol))
            let cellFrame = CGRect(x: xOffSet[perCol], y: yOffSet[perRow], width: cellSize.width, height: cellSize.height)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = cellFrame
            cellAttributes.setObject(attributes, forKey: indexPath as NSCopying)
        }
        allAttributes.setValue(cellAttributes, forKey: "cell")
        
        // MARK: - Set Footer attributes
        for item in 0 ..< collectionView!.numberOfSections {
            let indexPath = IndexPath(item: item, section: 0)
            let footerFrame = CGRect(x: 0, y: frameHeight - foot_height, width: frameWidth, height: foot_height)
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
            attributes.frame = footerFrame
            footerAttributes.setObject(attributes, forKey: indexPath as NSCopying)
        }
        allAttributes.setValue(footerAttributes, forKey: UICollectionElementKindSectionFooter)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: frameWidth, height: frameHeight)
    }
        
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        let allKeys:[NSMutableDictionary] = allAttributes.allValues as! [NSMutableDictionary]
        for key in allKeys {
            let attributeDict: [UICollectionViewLayoutAttributes] = key.allValues as! [UICollectionViewLayoutAttributes]
            for attribute in attributeDict {
                if rect.intersects(attribute.frame) {
                    attributes.append(attribute)
                }
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (cellAttributes[indexPath] as! UICollectionViewLayoutAttributes)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return (footerAttributes[indexPath] as! UICollectionViewLayoutAttributes)
    }
}

// MARK: - Responding to Collection View Updates
extension CellBehaviorController {
//    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
//        <#code#>
//    }
}
