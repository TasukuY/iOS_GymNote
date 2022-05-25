//
//  InterfaceController.swift
//  GymNote WatchKit Extension
//
//  Created by Tasuku Yamamoto on 5/10/22.
//

import WatchKit
import Foundation

class GymNoteInterfaceController: WKInterfaceController {

    @IBOutlet weak var testButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    
    
    @IBAction func testButtonTapped() {
        print("Button Got Tapped")
        testButton.setTitle("Tapped")
    }
    
    
    
}
