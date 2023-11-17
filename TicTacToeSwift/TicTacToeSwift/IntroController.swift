//
//  IntroController.swift
//  TicTacToeSwift
//
//  Created by Jonathan Sillak on 17.11.2023.
//

import UIKit

class IntroController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IntroController viewDidLoad()")
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "StartX":
            if let vc = (segue.destination as? TicTacToeControlerViewController) {
                vc.nextMoveBy = "❌"
            }
        case "StartO":
            if let vc = (segue.destination as? TicTacToeControlerViewController) {
                vc.nextMoveBy = "⭕️"
            }
        default:
            print("unknown segue: \(segue.identifier ?? "nil")")
        }
    }

}
