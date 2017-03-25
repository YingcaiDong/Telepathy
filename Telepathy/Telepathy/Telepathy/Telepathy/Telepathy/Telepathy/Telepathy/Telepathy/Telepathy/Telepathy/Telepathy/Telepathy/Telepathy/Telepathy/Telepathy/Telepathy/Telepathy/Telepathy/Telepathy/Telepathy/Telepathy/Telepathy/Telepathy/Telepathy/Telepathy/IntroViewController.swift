//
//  ViewController.swift
//  Telepathy
//
//  Created by Yingcai Dong on 2017-02-27.
//  Copyright © 2017 Yingcai Dong. All rights reserved.
//

import UIKit
protocol IntroViewControllerDelegate: class{
    func IntroViewController(didPressStander: Bool)
}
class IntroViewController: UIViewController {
    weak var delegate: IntroViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func standard(_ sender: UIButton) {
        if let delegate = delegate {
            let flag = true
            delegate.IntroViewController(didPressStander: flag)
            print("test 1 standard")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "st_seg" {
            let delegat_er = segue.destination as! NumberPadViewController
            self.delegate = delegat_er
        }
    }
}

