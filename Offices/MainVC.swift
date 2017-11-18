//
//  MainVC.swift
//  Offices
//
//  Created by Admin on 18.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Moya

class MainVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .red
    
    ServerManager.shared.getInstitutions(with: { print($0) }) { print($0) }
  }
}

