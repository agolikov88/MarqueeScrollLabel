//
//  ViewController.swift
//  MarqueeScrollLabel
//
//  Created by Alexander Golikov on 7/26/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customizedAppearanceLabel: MarqueeScrollLabel!

    @IBOutlet weak var noTextFadeLabel: MarqueeScrollLabel!

    @IBOutlet weak var shortTextLabel: MarqueeScrollLabel!

    private let shortText = "Short text"
    private let longText = "Long text Long text Long text Long text Long text Long text Long text Long text Long text"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func toggleAnimation(_ sender: UISwitch) {
        customizedAppearanceLabel.animating = sender.isOn
        noTextFadeLabel.animating = sender.isOn
        shortTextLabel.animating = sender.isOn
    }

    @IBAction func toggleShortText(_ sender: UISwitch) {
        shortTextLabel.text = sender.isOn ? shortText : longText
    }
}
