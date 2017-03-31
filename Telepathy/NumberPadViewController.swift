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
    let inset: CGFloat = 15
    let foot_height: CGFloat = 50
    var cnt: Int = 0
    var binaryNumber: UInt8 = 0b0
    
    weak var delegate: NumberPadViewControllerDelegate?
    
    @IBOutlet weak var aFooter: TwoButton!
    
    override func viewDidLoad() {
        self.collectionView?.register(TwoButton.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
    }
}

// MARK: - Generate array based on binary
extension NumberPadViewController {
    // generate the number
    func generateNumberSheet() -> [[Int]] {
        var array:[[Int]] = []
        var subArray:[Int] = []
        for num in 1...100 {
            var binary: UInt8 = UInt8(num)
            for index in 0...6 {
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
        if cnt >= 7 {
            return 1
        } else {
            return arrayPad[cnt].count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "displayNum", for: indexPath) as! Cell2DisplayNumber
        if cnt >= 7 {
            cell.NumberCell.text = String(Int(binaryNumber))
            return cell
        } else {
            cell.NumberCell.text = String(arrayPad[cnt][indexPath.row])
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! TwoButton
        
        self.delegate = aFooter
        self.delegate?.howManyTimes(self, didUser: cnt)
        
        aFooter.delegate = self
        footer.addSubview(aFooter)
        return footer
    }
}

// MARK: - Enable section footer and two button
extension NumberPadViewController: TwoButtonDelegate {
    
    func button(_ button: TwoButton, correctButton press: Bool) {
        if press {
            if cnt < 7 {
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
