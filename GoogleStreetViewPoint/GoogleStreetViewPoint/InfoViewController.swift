//
//  InfoViewController.swift
//  GoogleStreetViewPoint
//
//  Created by Edivando Alves on 4/8/16.
//  Copyright © 2016 J7ss. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController{
    
    @IBOutlet var logo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.layer.cornerRadius = 20
        logo.clipsToBounds = true
    }
    
}


