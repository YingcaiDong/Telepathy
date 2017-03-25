//
//  File.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-02-27.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit

protocol NumberPadViewControllerDelegate: class {
    func howManyTimes(_ controller: NumberPadViewController, didUser press: Int)
}

class NumberPadViewController: UICollectionViewController {
    
    var numberPad_flag: Bool = false
    var arrayPad = [[Int]]()
    let itemsPerRow: CGFloat = 5
    let inset: CGFloat = 15
    let foot_height: CGFloat = 30
    var cnt: Int = 0
    var binaryNumber: UInt8 = 0b0
    
    weak var datasource: UICollectionViewDataSource?
    weak var delegate: NumberPadViewControllerDelegate?
    
    override func viewDidLoad() {
        
    }
}

// MARK: - Generate array based on binary
extension NumberPadViewController {
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

// MARK: - Dispaly array[cnt] elements
extension NumberPadViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayPad = generateNumberSheet()
        if cnt > 5 {
            return 1
        } else {
            return arrayPad[cnt].count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayNum", for: indexPath) as! Cell2DisplayNumber
        
        if cnt > 5 {
            cell.NumberCell.text = String(Int(binaryNumber))
        } else {
            cell.NumberCell.text = String(arrayPad[cnt][indexPath.row])
        }
        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK: - Custom collection view cell size
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

// MARK: - Enable section footer and two button
extension NumberPadViewController: TwoButtonDelegate {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let foot_view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footbutton", for: indexPath)
        
        let footButton: TwoButton = foot_view as! TwoButton
        footButton.delegate = self
        
        self.delegate = footButton
        delegate?.howManyTimes(self, didUser: cnt)
        
        return foot_view
    }

    
    func button(_ button: TwoButton, correctButton press: Bool) {
        if press {
            if cnt < 6 {
                binaryNumber |= UInt8(0b1 << cnt)
            }
            cnt += 1
            self.collectionView?.reloadData()
            
        }
        delegate?.howManyTimes(self, didUser: cnt)
    }
    
    func button(_ button: TwoButton, wrongButton press: Bool) {
        if press {
            cnt += 1
            self.collectionView?.reloadData()
        }
        delegate?.howManyTimes(self, didUser: cnt)
    }
    
    func button(_ button: TwoButton, nextRoundButton press: Bool) {
        if press {
            cnt = 0
            self.collectionView?.reloadData()
        }
    }
}
