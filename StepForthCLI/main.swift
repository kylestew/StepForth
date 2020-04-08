import Foundation
import CommandLineKit

// not included as framework since its made for iOS
// TODO: upgrade it for MacOS as well
let forth = Forth()

if let ln = LineReader() {
    print("StepForth")

    var done = false
    while !done {
        do {
            let input = try ln.readLine(prompt: "> ",
                                        maxCount: 80,
                                        strippingNewline: true,
                                        promptProperties: TextProperties(.green, nil, .bold),
                                        readProperties: TextProperties(.blue, nil, .bold))

            if input == "bye" {
                break
            } else {

                let output = forth.read(line: input)
                print(output)

            }

        } catch LineReaderError.CTRLC {
            print("\nCTRL+C. Bye!")
            done = true
        } catch {
            print(error)
        }
    }
}
