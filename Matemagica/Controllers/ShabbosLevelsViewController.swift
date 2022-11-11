//
//  ShabbosLevelsViewController.swift
//  Matemagica
//
//  Created by dani on 10/16/22.
//  Copyright © 2022 Dani Springer. All rights reserved.
//

import UIKit

class ShabbosLevelsViewController: UITableViewController {

    // MARK: Outlets

    @IBOutlet var helpButton: UIButton!


    // MARK: Properties

    var myThemeColor: UIColor!
    var myTitle: String!


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if CommandLine.arguments.contains("--matemagicaScreenshots") {
            // We are in testing mode, make arrangements if needed
            UIView.setAnimationsEnabled(false)
        }

        self.title = self.myTitle
        setThemeColorTo(myThemeColor: myThemeColor)

        helpButton.addTarget(self, action: #selector(showHelp),
                             for: .touchUpInside)

        helpButton.setTitleNew("Help")
        let helpItem = UIBarButtonItem(customView: helpButton)

        navigationItem.rightBarButtonItem = helpItem
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        let shouldShowHelp = restoreAndShouldShowHelp()
        guard shouldShowHelp else {
            return
        }

        if !ud.bool(forKey: Const.userSawShabbosTutorial) {
            showHelp()
        }

    }


    // MARK: Helpers

    func restoreAndShouldShowHelp() -> Bool {
        guard let restoredLevelIndex: Int = ud.value(
            forKey: Const.levelIndexKey) as? Int else {
            return true
        }
        ud.removeObject(forKey: Const.levelIndexKey)

        if restoredLevelIndex >= Const.shabbosLevelsCount {
            let alert = createAlert(alertReasonParam: .lastLevelCompleted, style: .alert)
            present(alert, animated: true)
            return false
        }
        showLevelFor(IndexPath(row: restoredLevelIndex, section: 0))
        return false
    }


    @objc func showHelp() {

        let tutorialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
                withIdentifier: Const.shabbosTutorialViewController)
        as! ShabbosTutorialViewController

        present(tutorialVC, animated: true)
    }


    // MARK: Delegates

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Const.shabbosLevelsCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Const.shabbosLevelCell) as! LevelTableViewCell
        cell.selectionStyle = .none
        cell.levelNumberLabel.text = "⭐️ Level \(indexPath.row + 1)"
        let levelMaxNumber = Const.rangeAddedPerLevel * (indexPath.row + 1)
        cell.numbersRangeLabel.text = """
        🧮 Numbers between 1 and \(levelMaxNumber)
        """

        cell.fakeBackgroundView.backgroundColor = myThemeColor
        cell.fakeBackgroundView.layer.cornerRadius = 8

        return cell
    }


    func showLevelFor(_ indexPath: IndexPath) {
        let shabbosVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: Const.shabbosViewController) as! ShabbosViewController
        shabbosVC.levelNumberIndex = indexPath.row
        let levelMaxNumber = Const.rangeAddedPerLevel * (indexPath.row + 1)
        shabbosVC.numbersRange = 1...levelMaxNumber
        shabbosVC.myThemeColor = myThemeColor
        self.navigationController!.pushViewController(shabbosVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLevelFor(indexPath)
    }

}
