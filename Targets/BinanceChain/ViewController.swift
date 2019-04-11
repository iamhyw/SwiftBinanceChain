import UIKit
import BinanceChain

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Run tests
        self.test = BinanceChain.Test()
        self.test?.testAPI() {
            print("tests complete")
        }

    }


}

