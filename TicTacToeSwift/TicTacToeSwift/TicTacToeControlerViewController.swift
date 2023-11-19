//
//  TicTacToeControlerViewController.swift
//  TicTacToeSwift
//
//  Created by Jonathan Sillak on 17.11.2023.
//

import UIKit

class TicTacToeControlerViewController: UIViewController {
    
    var nextMoveBy: String = "❌"
    
    @IBOutlet weak var nextMoveLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("TicTacToeControlerViewController viewDidLoad()")
        nextMoveLabel.text = nextMoveBy
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
}
