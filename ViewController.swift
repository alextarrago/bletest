//
//  ViewController.swift
//
//  Created by Alex Tarragó on 07/11/2016.
//  Copyright © 2016 KIASu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KiasuSDK.sharedInstance.discover()
    }
}
