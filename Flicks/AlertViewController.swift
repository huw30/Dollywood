//
//  AlertViewController.swift
//  Flicks
//
//  Created by Raina Wang on 9/14/17.
//  Copyright © 2017 Raina Wang. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var errorMessage: UILabel!

    @IBAction func dissmissMessage(_ sender: Any) {
        removeSelf()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func removeSelf() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
