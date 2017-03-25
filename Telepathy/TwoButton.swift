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
}

class TwoButton: UICollectionReusableView {
    weak var delegate: TwoButtonDelegate?
    
    @IBAction func yesButton(_ sender: UIButton) {
        let message = true
        delegate?.button(self, correctButton: message)
}
    
    @IBAction func noButton(_ sender: Any) {
        let message = true
        delegate?.button(self, wrongButton: message)
    }
}
