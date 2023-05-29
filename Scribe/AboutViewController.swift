//
//  AboutViewController.swift
//  Scribe
//
//  Created by Saurabh Jamadagni on 29/05/23.
//

import UIKit

class AboutViewController: UIViewController {
  
  @IBOutlet weak var communityTable: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "About Scribe"
    
  }
}
