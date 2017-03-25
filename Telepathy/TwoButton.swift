//
//  TwoButton.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-03-24.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit

protocol TwoButtonDelegate: class {
    func button(_ button: TwoButton, correctButton press: Bool)
    func button(_ button: TwoButton, wrongButton press: Bool)
    func button(_ button: TwoButton, nextRoundButton press: Bool)
}

class TwoButton: UICollectionReusableView {
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var nextRound: UIButton!
    
    weak var delegate: TwoButtonDelegate?
    var buttonPressCnt: Int = 0
    
    @IBAction func yesButton(_ sender: UIButton) {
        let message = true
        delegate?.button(self, correctButton: message)
}
    
    @IBAction func noButton(_ sender: Any) {
        let message = true
        delegate?.button(self, wrongButton: message)
    }
    
    @IBAction func nextRound(_ sender: UIButton) {
        let message = true
        delegate?.button(self, nextRoundButton: message)
    }
}

extension TwoButton: NumberPadViewControllerDelegate {
    func howManyTimes(_ controller: NumberPadViewController, didUser press: Int) {
        buttonPressCnt = press
        if buttonPressCnt < 6 {
            yesButton.isEnabled = true
            yesButton.isHidden = false
            
            noButton.isEnabled = true
            noButton.isHidden = false
            
            nextRound.isEnabled = false
            nextRound.isHidden = true
        } else {
            yesButton.isEnabled = false
            yesButton.isHidden = true
            
            noButton.isEnabled = false
            noButton.isHidden = true
            
            nextRound.isEnabled = true
            nextRound.isHidden = false
        }
    }
}
