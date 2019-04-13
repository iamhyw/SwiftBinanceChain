import Foundation
import Darwin
import Commander

let test = Test()

test.runAllTestsOnTestnet()

/*
test.testAPI() {
    test.testBroadcast()
    exit(0)
}
*/

RunLoop.main.run()
