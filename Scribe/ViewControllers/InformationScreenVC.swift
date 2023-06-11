//
//  InformationScreenVC.swift
//

import UIKit

class InformationScreenVC: UIViewController {
  @IBOutlet var headingLabel: UILabel!
  @IBOutlet var spacer: UIView!

  var text: String = ""
  var screenTitle: String = ""

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = screenTitle
    headingLabel.text = text
    spacer.backgroundColor = .clear
  }
}
