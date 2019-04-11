import Foundation
import Darwin
import Commander

let test = Test()
test.testAPI() {
    exit(0)
}

RunLoop.main.run()
