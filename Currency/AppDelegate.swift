//
//  AppDelegate.swift
//  EUR
//
//  Created by Eruqul on 11/10/20.
//  Copyright © 2019 mrb. All rights reserved.
//

import Cocoa
import SwiftSoup
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let calcPop = NSPopover()
    let menuPop = NSPopover()
    var eventMonitor: EventMonitor?
    let imageNames: [String] = ["eur", "usd", "gbp", "ddk", "sek"]
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        self.statusItem.length = 70

        if let button = self.statusItem.button{
            button.imageScaling =  .NSScaleProportionally   //.scaleProportionallyUpOrDown
            button.imagePosition = .imageLeft
            button.frame = CGRect(x: 0, y: 2, width: button.frame.width, height: button.frame.height - 4)
            button.action = #selector(togglePopover(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        let queue = DispatchQueue(label: "work-queue")
        
        queue.async {
            self.doFetch()
        }
        
        
        
        menuPop.contentViewController = MenuViewController.freshController()
        calcPop.contentViewController = EurViewController.freshController()
    }
    
    @objc func togglePopover(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
 
        if event.type == NSEvent.EventType.leftMouseUp {
            if menuPop.isShown {
                closeMenuPopover(sender: sender)
            }
            if calcPop.isShown {
                closeCalcPopover(sender: sender)
            } else {
                showCalcPopover(sender: sender)
            }
        }
    }
    
    func selectCurrency(_ index: Int) {
        SharedVar.sharedInstance.setIndex(idx: index)
        closeMenuPopover(sender: nil)
        
        if let button = self.statusItem.button{
            button.image = NSImage(named: NSImage.Name(imageNames[index]))
            button.title = String(SharedVar.sharedInstance.getCurrency())
        }
    }
    
    func showCalcPopover(sender: Any?) {
        if let button = statusItem.button {
            calcPop.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closeCalcPopover(sender: Any?) {
        calcPop.performClose(sender)
        eventMonitor?.stop()
        (calcPop.contentViewController as! EurViewController).reset()
    }
    
    func showMenuPopover(sender: Any?) {
        
        if let button = sender {
            menuPop.show(relativeTo: (button as AnyObject).bounds, of: button as! NSView, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
            
        }

    }
    
    func closeMenuPopover(sender: Any?) {
        menuPop.performClose(sender)
        eventMonitor?.stop()
    }
    
    func doFetch() {
        while true {
            Alamofire.request("https://www.arionbanki.is").responseString() {response in
                if let htmlContent = response.result.value {
                    do {
                        let doc: Document = try SwiftSoup.parse(htmlContent)
                        let eurCur = try doc.select("td.currency-changer__sell").get(3)
                        var cur: [Float] = [0.0, 0.0, 0.0, 0.0, 0.0]
                        cur[0] = Float(try eurCur.text())!
                        let usdCur = try doc.select("td.currency-changer__sell").get(1)
                        cur[1] = Float(try usdCur.text())!
                        let gbpCur = try doc.select("td.currency-changer__sell").get(2)
                        cur[2] = Float(try gbpCur.text())!
                        let ddkCur = try doc.select("td.currency-changer__sell").get(5)
                        cur[3] = Float(try ddkCur.text())!
                        let sekCur = try doc.select("td.currency-changer__sell").get(7)
                        cur[4] = Float(try sekCur.text())!
                        
                        print(cur)
                        SharedVar.sharedInstance.setCurrency(cur: cur)
                    } catch let error {
                        print("Error: \(error)")
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.selectCurrency(SharedVar.sharedInstance.getIndex())
                }
                
            }
            usleep(1000000 * 60 * 5)
        }
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}

