//
//  EntryViewController.swift
//  storyboard
//
//  Created by Jonathan Sillak on 10.11.2023.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var labelGreeting: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBAction func touchOk(_ sender: Any) {
        labelGreeting.text = textFieldName.text
    }
        
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
    }
}
