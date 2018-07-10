//
//  PagesViewController.swift
//  Guess My Number Fun
//
//  Created by Dani Springer on 04/07/2018.
//  Copyright © 2018 Dani Springer. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class PagesViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var pageContentLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var myToolbar: UIToolbar!
    
    
    // MARK: Properties
    
    struct Page {
        let key: Int
        let value: [Int]
    }
    
    let pagesArrayOfDicts = [
        1: [1, 3, 5, 7, 9, 11,
         13, 15, 17, 19, 21, 23,
         25, 27, 29, 31, 33, 35,
         37, 39, 41, 43, 45, 47,
         49, 51, 53, 55, 57, 59,
         61, 63],
        2: [2, 3, 6, 7, 10, 11,
         14, 15, 18, 19, 22, 23,
         26, 27, 30, 31, 34, 35,
         38, 39, 42, 43, 46, 47,
         50, 51, 54, 55, 58, 59,
         62, 63],
        4: [4, 5, 6, 7, 12, 13,
         14, 15, 20, 21, 22, 23,
         28, 29, 30, 31, 36, 37,
         38, 39, 44, 45, 46, 47,
         52, 53, 54, 55, 60, 61,
         62, 63],
        8: [8, 9, 10, 11, 12, 13,
         14, 15, 24, 25, 26, 27,
         28, 29, 30, 31, 40, 41,
         42, 43, 44, 45, 46, 47,
         56, 57, 58, 59, 60, 61,
         62, 63],
        16: [16, 17, 18, 19, 20, 21,
         22, 23, 24, 25, 26, 27,
         28, 29, 30, 31, 48, 49,
         50, 51, 52, 53, 54, 55,
         56, 57, 58, 59, 60, 61,
         62, 63],
        32: [32, 33, 34, 35, 36, 37,
         38, 39, 40, 41, 42, 43,
         44, 45, 46, 47, 48, 49,
         50, 51, 52, 53, 54, 55,
         56, 57, 58, 59, 60, 61,
         62, 63]]
    
    var arrayOfPages = [Page]()
    
    var shuffledPagesByContent = [Page]()
    
    var shuffledPagesByOrder = [Page]()
    
    var userNumber = 0
    
    enum userOptions: String {
        case yes = "yes"
        case no = "no"
        case none = "none"
    }
    
    var userSelection = "nil"
    
    var currentPageFake = 1
    var currentPageReal = 0
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.isHidden = true
        
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 40),
                NSAttributedStringKey.foregroundColor : view.tintColor,
                ], for: .normal)
        
        myToolbar.setBackgroundImage(UIImage(),
                                        forToolbarPosition: .any,
                                        barMetrics: .default)
        myToolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        for page in pagesArrayOfDicts {
            arrayOfPages.append(Page(key: page.key, value: page.value))
        }
        
        for page in arrayOfPages {
            let shuffledPageContent = page.value.shuffled()
            shuffledPagesByContent.append(Page(key: page.key, value: shuffledPageContent))
        }
        
        shuffledPagesByOrder = shuffledPagesByContent.shuffled()
        
        
        pageNumberLabel.text = "Think of a number 1-63.\nGreat. Storytime! My book has 6 pages. But all of them have just... numbers!"
        pageContentLabel.text = ""
        
        let okButton = UIBarButtonItem(title: "👍", style: .plain, target: self, action: #selector(showNextPage))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myToolbar.setItems([space, okButton], animated: true)
        
    }
    
    
    // Helpers
    
    
    @objc func showNextPage() {
        if currentPageFake > shuffledPagesByOrder.count {
            showResult()
            return
        }
        pageNumberLabel.text = "Is your number in page #\(currentPageFake)?"
        pageContentLabel.text = "\(prettifyPage(page: shuffledPagesByOrder[currentPageReal].value))"
        
        let yesButton = UIBarButtonItem(title: "👍", style: .plain, target: self, action: #selector(addValue))
        let noButton = UIBarButtonItem(title: "👎", style: .plain, target: self, action: #selector(dontAddValue))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myToolbar.setItems([yesButton, space, noButton], animated: true)
        
    }
    
    @objc func addValue() {
        // add value
        userNumber += shuffledPagesByOrder[currentPageReal].key
        currentPageFake += 1
        currentPageReal += 1
        showNextPage()
    }
    
    @objc func dontAddValue() {
        currentPageFake += 1
        currentPageReal += 1
        showNextPage()
    }
    
    @objc func showResult() {
        
        pageContentLabel.text = ""
        pageNumberLabel.text = "You thought:"
        resultLabel.text = "\(userNumber)"
        resultLabel.isHidden = false
        
        let doneButton = UIBarButtonItem(title: "🎉", style: .plain, target: self, action: #selector(doneButtonPressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        myToolbar.setItems([space, doneButton, space], animated: true)
    }
    
    
    func prettifyPage(page: [Int]) -> String {
        var newPage = ""
        
        for number in page {
            var tempNumber = "\(number)"
            if tempNumber.count == 1 {
                tempNumber = "0\(tempNumber)"
            }
            newPage.append("\(tempNumber) ")
        }
        
        return newPage
    }
    
    
    // MARK: Actions
    
    @objc func doneButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}











