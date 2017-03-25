//
//  File.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-02-27.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit

class NumberPadViewController: UICollectionViewController {
    
    var numberPad_flag: Bool = false
    var arrayPad = [[Int]]()
    let itemsPerRow: CGFloat = 5
    let inset: CGFloat = 15
    let foot_height: CGFloat = 30
    var footButton: TwoButton? = nil
    var cnt: Int = 0
    
    weak var datasource: UICollectionViewDataSource?
    
    override func viewDidLoad() {
        
    }
    
    // generate the number
    func generateNumberSheet() -> [[Int]] {
        var array:[[Int]] = []
        var subArray:[Int] = []
        for num in 1...50 {
            var binary: UInt8 = UInt8(num)
            for index in 0...5 {
                switch num {
                case 1:
                    if binary & UInt8(1) == 0b1 {   // key bit is 1
                        subArray.append(num)
                        array.append(subArray)
                        subArray.removeAll()
                    } else {
                        subArray.removeAll()
                        array.append(subArray)
                    }
                default:
                    if binary & UInt8(1) == 0b1 {
                        array[index].append(num)
                    }
                }
                binary = binary >> 1
            }
        }
        return array
    }
}

extension NumberPadViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayPad = generateNumberSheet()
        return arrayPad[cnt].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayNum", for: indexPath) as! Cell2DisplayNumber
        cell.NumberCell.text = String(arrayPad[cnt][indexPath.row])
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension NumberPadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets2Edge = inset * (itemsPerRow+1)
        let insets2inLine = inset * itemsPerRow
        let theWidth = (view.frame.width - insets2Edge) / itemsPerRow
        let theHeight = (view.frame.height - insets2inLine - foot_height) / itemsPerRow
        
        return CGSize(width: theWidth, height: theHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(inset, inset, 0, inset)
    }
    
}

extension NumberPadViewController: TwoButtonDelegate {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let foot_view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footbutton", for: indexPath)
        footButton = foot_view as! TwoButton
        footButton!.delegate = self
        return foot_view
    }

    
    func button(_ button: TwoButton, correctButton press: Bool) {
        if press {
            print("yes")
            cnt += 1
            self.collectionView?.reloadData()
            
        }
    }
    
    func button(_ button: TwoButton, wrongButton press: Bool) {
        if press {
            print("wrong")
            cnt += 1
            self.collectionView?.reloadData()
        }
    }
}
