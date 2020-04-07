import UIKit


//        var tokenizer = Tokenizer(" 1 21 321 ")

var input = "hello world\" test 123"
let range = input.range(of: #"[^\"]*"#, options: .regularExpression)

if let range = range {
    let token = String(input[range])
    token

    let remainder = input[range.upperBound...]
    remainder
}
