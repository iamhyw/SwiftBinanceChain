import Foundation
import Darwin

let test = Test()
test.testAPI() {
    exit(0)
}

RunLoop.main.run()
