//
//  MenuViewController.swift
//  Guess
//
//  Created by Daniel Springer on 05/07/2018.
//  Copyright © 2021 Daniel Springer. All rights reserved.
//

import UIKit
import MessageUI


class MenuViewController: UIViewController,
                          UITableViewDataSource,
                          UITableViewDelegate {


    // MARK: Outlets

    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var aboutButton: UIBarButtonItem!


    // MARK: Properties

    let myDataSource = [NSLocalizedString("The Magic Formula", comment: ""),
                        NSLocalizedString("Book", comment: ""),
                        NSLocalizedString("The Chess Puzzle", comment: ""),
                        NSLocalizedString("Higher Lower", comment: ""),
                        NSLocalizedString("MatheMagic", comment: "")]
    let myImageSource = ["plus.slash.minus", "book", "8.square",
                         "arrow.up.arrow.down", "wand.and.stars"]

    let tintColorsArray: [UIColor] = [
        .systemPurple,
        .systemOrange,
        .systemBlue,
        .systemYellow,
        .systemRed
    ]

    let menuCell = "MenuCell"

    let myThemeColor: UIColor = .systemBlue


    // MARK: Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        setThemeColorTo(myThemeColor: myThemeColor)

        if let selectedRow = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: selectedRow, animated: true)
        }

        myTableView.rowHeight = UITableView.automaticDimension

        aboutButton.menu = infoMenu()
        aboutButton.image = UIImage(systemName: "ellipsis.circle")
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !UserDefaults.standard.bool(forKey: Const.UDef.didShowSplashScreen) {
            #warning("uncomment below line")
            //UserDefaults.standard.set(true, forKey: Const.UDef.didShowSplashScreen)
            showTutorial()
        }
    }


    // MARK: Create menu

    func infoMenu() -> UIMenu {
        let shareApp = UIAction(title: Const.Misc.shareTitleMessage, image: UIImage(systemName: "heart"),
                                state: .off) { _ in
            self.shareApp()
        }
        let contact = UIAction(title: Const.Misc.sendFeedback, image: UIImage(systemName: "envelope"),
                               state: .off) { _ in
            self.launchEmail()
        }
        let review = UIAction(title: Const.Misc.leaveReview,
                              image: UIImage(systemName: "hand.thumbsup"), state: .off) { _ in
            self.requestReview()
        }
        let moreApps = UIAction(title: Const.Misc.showAppsButtonTitle, image: UIImage(systemName: "apps.iphone"),
                                state: .off) { _ in
            self.showApps()
        }

        let tutorial = UIAction(title: Const.Misc.tutorial, image: UIImage(systemName: "info.circle"),
                                state: .off) { _ in
            self.showTutorial()
        }

        let version: String? = Bundle.main.infoDictionary![Const.Misc.appVersion] as? String
        var myTitle = Const.Misc.appName
        if let safeVersion = version {
            myTitle += " \(Const.Misc.version) \(safeVersion)"
        }

        let infoMenu = UIMenu(title: myTitle, image: nil, identifier: .none, options: .displayInline,
                              children: [tutorial, contact, review, shareApp, moreApps])
        return infoMenu
    }


    // MARK: Show Apps

    func showApps() {

        let myURL = URL(string: Const.Misc.appsLink)

        guard let safeURL = myURL else {
            let alert = createAlert(alertReasonParam: .unknown)
            present(alert, animated: true)
            return
        }

        UIApplication.shared.open(safeURL, options: [:], completionHandler: nil)

    }


    func showTutorial() {
        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: Const.StoryboardID.splash)
        present(tutorialVC, animated: true)
    }


    // MARK: TableView Delegate

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Amaze Your Friends", comment: "header")
        } else {
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDataSource.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: menuCell) as! MainMenuTableViewCell

        cell.myLabel.text = myDataSource[(indexPath as NSIndexPath).row]
        cell.myImageView.image = UIImage(systemName: myImageSource[(indexPath as NSIndexPath).row])
        cell.myImageView.tintColor = tintColorsArray[(indexPath as NSIndexPath).row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: Const.StoryboardID.main, bundle: nil)

        let cell = tableView.cellForRow(at: indexPath) as? MainMenuTableViewCell

        switch cell?.myLabel?.text {
            case myDataSource[0]:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.formulaVC) as? FormulaViewController
                if let toPresent = controller {
                    controller?.myTitle = myDataSource[indexPath.row]
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case myDataSource[1]:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.bookVC) as? BookViewController
                if let toPresent = controller {
                    controller?.myTitle = myDataSource[indexPath.row]
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case myDataSource[2]:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.queensVC) as? QueensViewController
                if let toPresent = controller {
                    controller?.myTitle = myDataSource[indexPath.row]
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case myDataSource[3]:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.higherVC) as? HigherLowerViewController
                if let toPresent = controller {
                    controller?.myTitle = myDataSource[indexPath.row]
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            case myDataSource[4]:
                let controller = storyboard.instantiateViewController(
                    withIdentifier: Const.StoryboardID.magicVC) as? MagicViewController
                if let toPresent = controller {
                    controller?.myTitle = myDataSource[indexPath.row]
                    self.navigationController?.pushViewController(toPresent, animated: true)
                }
            default:
                let alert = createAlert(alertReasonParam: AlertReason.unknown)
                alert.view.layoutIfNeeded()
                present(alert, animated: true)
        }
    }


    // MARK: Actions

    func shareApp() {
        let message = Const.Misc.shareBodyMessage
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = aboutButton
        activityController.completionWithItemsHandler = { (_, _: Bool, _: [Any]?, error: Error?) in
            guard error == nil else {
                let alert = self.createAlert(alertReasonParam: AlertReason.unknown)
                alert.view.layoutIfNeeded()
                self.present(alert, animated: true)
                return
            }
        }
        present(activityController, animated: true)
    }


}


extension MenuViewController: MFMailComposeViewControllerDelegate {


    // MARK: Helpers

    func launchEmail() {

        var emailTitle = Const.Misc.appName
        if let version = Bundle.main.infoDictionary![Const.Misc.appVersion] {
            emailTitle += " \(version)"
        }
        let messageBody = Const.Misc.emailSample
        let toRecipents = [Const.Misc.emailAddress]
        let mailComposer: MFMailComposeViewController = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipents)
        DispatchQueue.main.async {
            self.present(mailComposer, animated: true, completion: nil)
        }
    }


    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }


}


extension MenuViewController {


    func requestReview() {
        // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
        //       You can find the App Store ID in your app's product URL
        guard let writeReviewURL = URL(string: Const.Misc.reviewLink)
        else {
            fatalError("expected valid URL")

        }
        UIApplication.shared.open(writeReviewURL,
                                  options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]),
                                  completionHandler: nil)
    }
}


// Helper function inserted by Swift 4.2 migrator.

private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(
    _ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in
            (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
    }
