//
//  File.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-02-27.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit

class NumberPadViewController: UIViewController, UICollectionViewDataSource, IntroViewControllerDelegate {
    
    var numberPad_flag: Bool = false
    weak var datasource: UICollectionViewDataSource?
    
    @IBOutlet weak var textfield: UITextField!
    
    //weak var controller: IntroViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        display()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func display() {
        if numberPad_flag {
            textfield.text = "stander"
        } else {
            textfield.text = "chaotic"
        }
    }
    
    // generate the number
    
    
    // delegate function
    func IntroViewController(didPressStander: Bool) {
        numberPad_flag = didPressStander
        display()
        print("test standard")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("section = \(section)")
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
