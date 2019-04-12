import Cocoa
import BinanceChain

class ViewController: NSViewController {

    private var test: Test?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Run tests
        self.test = Test()
        self.test?.testAPI() {
            print("tests complete")
            self.test?.testWallet()
            self.test?.testWebSocket()
        }
        
    }

}

