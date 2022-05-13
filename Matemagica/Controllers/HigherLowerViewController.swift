//
//  HigherLowerViewController.swift
//  Math Magic
//
//  Created by Daniel Springer on 05/07/2018.
//  Copyright © 2022 Daniel Springer. All rights reserved.
//

import UIKit


class HigherLowerViewController: UIViewController {


    // MARK: Outlets

    var myTitle: String!
    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var lowerButton: UIButton!
    @IBOutlet weak var higherButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!

    @IBOutlet weak var progressBar: UIProgressView!


    // MARK: Properties

    var high = 1001
    var low = 0
    var guess = 0
    var diff = 0
    var halfDiff = 0
    var tries = 0

    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.myTitle
        setThemeColorTo(myThemeColor: myThemeColor)

        lowerButton.isHidden = true
        higherButton.isHidden = true

        correctButton.removeTarget(nil, action: nil, for: .allEvents)
        lowerButton.removeTarget(nil, action: nil, for: .allEvents)
        higherButton.removeTarget(nil, action: nil, for: .allEvents)

        correctButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        higherButton.addTarget(self, action: #selector(higher), for: .touchUpInside)
        lowerButton.addTarget(self, action: #selector(lower), for: .touchUpInside)

        correctButton.setTitle(Const.Misc.okMessage, for: .normal)
        higherButton.setTitle(Const.Misc.higherMessage, for: .normal)
        lowerButton.setTitle(Const.Misc.lowerMessage, for: .normal)

        higherButton.sizeToFit()
        lowerButton.sizeToFit()
        correctButton.sizeToFit()

        progressBar.setProgress(0, animated: false)

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        progressBar.setProgress(1/11, animated: true)
    }


    // MARK: Helpers

    @objc func start() {
        high = 1001
        low = 0
        guess = 0
        diff = 0
        halfDiff = 0
        tries = 0
        showNextGuess()
    }


    @objc func showNextGuess() {
        tries += 1
        diff = high - low
        if diff == 3 {
            halfDiff = 2
        } else {
            halfDiff = diff / 2
        }
        guess = low + halfDiff
        guessLabel.isHidden = false
        let myAttrString = attrifyString(
            preString: "Is your number...\n", toAttrify: "\(guess)", color: myThemeColor)

        myAttrString.append(attrifyString(
            preString: "\n\nTries used:\n", toAttrify: "\(tries)", color: myThemeColor))
        myAttrString.append(NSAttributedString(string: "\n\nOtherwise: is it lower or higher?"))

        guessLabel.attributedText = myAttrString


        if halfDiff == 1 {
            let myAttrString = attrifyString(
                preString: "You thought:\n", toAttrify: "\(guess)", color: myThemeColor)

            myAttrString.append(attrifyString(
                preString: "\n\nTries used:\n", toAttrify: "\(tries)", color: myThemeColor))

            myAttrString.append(NSAttributedString(string: "\n\n"))

            guessLabel.attributedText = myAttrString


            // correct button
            correctButton.removeTarget(nil, action: nil, for: .allEvents)
            correctButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
            correctButton.setTitle(Const.Misc.correctMessage, for: .normal)
            lowerButton.isHidden = true
            higherButton.isHidden = true
            correctButton.isHidden = false
        } else {
            // all buttons
            correctButton.removeTarget(nil, action: nil, for: .allEvents)
            correctButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
            correctButton.setTitle(Const.Misc.correctMessage, for: .normal)
            correctButton.isHidden = false
            lowerButton.isHidden = false
            higherButton.isHidden = false
        }
        let myProgress: Float = (Float(tries) + 1.0) / 11.0
        progressBar.setProgress(myProgress, animated: true)
    }


    @objc func lower() {
        high = guess
        showNextGuess()
    }


    @objc func higher() {
        low = guess
        showNextGuess()
    }


    // MARK: Action

    @objc func doneButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }

}
