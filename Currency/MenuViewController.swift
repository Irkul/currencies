//
//  MenuViewController.swift
//  Currency
//
//  Created by Eruqul on 8/1/19.
//  Copyright © 2019 mrb. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectEur(_ sender: Any) {
        self.selectCurrency(0)
    }
    @IBAction func selectUsd(_ sender: Any) {
        self.selectCurrency(1)
    }
    
    @IBAction func selectGbp(_ sender: Any) {
        self.selectCurrency(2)
    }
    @IBAction func selectDdk(_ sender: Any) {
        self.selectCurrency(3)
    }
    
    @IBAction func selectSek(_ sender: Any) {
        self.selectCurrency(4)
    }
    
    @IBAction func selectQuit(_ sender: Any) {

        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.closeMenuPopover(sender: sender)
        appDelegate?.closeCalcPopover(sender: sender)

        let answer = dialogOKCancel(question: "Close the app?", text: "App will be terminated")
        
        if answer == true {
            NSApplication.shared.terminate(self)
        }
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        
        return false
    }
    
    func selectCurrency (_ index: Int) {
        let appDelegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.selectCurrency(index)
    }
}

extension MenuViewController {
    static func freshController() -> MenuViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MenuViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MenuViewController else {
            fatalError("Why can't I find MenuViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
