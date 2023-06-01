//
//  InformationScreenVC.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 30/05/23.
//

import UIKit

class InformationScreenVC: UIViewController {
  
  @IBOutlet weak var headingLabel: UILabel!
  @IBOutlet weak var spacer: UIView!
  
  var text: String = ""
  var screenTitle: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = screenTitle
    headingLabel.text = text
    spacer.backgroundColor = .clear
  }
  
}
