# Usage

### Creating standard patterns

```swift
import Patterns

//simple patterns
let plainTextPattern = Factory.text("[]") //matches "array[]"
let wholeWordPattern = Factory.word("an") //matches "target an object" but not "Random"
let prefixPattern = Factory.prefix("NS") //matches "NSObject"
let suffixPattern = Factory.suffix("ViewController") //matches "MyShinyViewController"

//shortcut patterns
let unixGlobPattern = Factory.wildcard("My*Cell*Builder") //matches "MyContactCellViewBuilder"
let suffixPattern = Factory.xcodeFilter(of: "aty") //matches "Factory"

//advanced patterns
let regexPattern = Factory.regex("[a]+b") //matches "0aaaaaab0"

```

### Building patterns using elements

```swift

let pattern = Builder.pattern(
            .char(in: "<"),
            .either([
                .repeating(.charNot(in: "<>\"'"), times: .atLeastOnce),
                [.quote,
                    .repeating(.charNot(in: "\""), times: .any),
                 .quote],
                [.apostrophe,
                    .repeating(.charNot(in: "'"), times: .any),
                 .apostrophe]
              ]),
          .char(in: ">"))
//same as regex: "<(?:(?:[^<>\"']+)|(?:\"[^\"]*\")|(?:'[^']*'))>"

```

### Boolean operations

```swift
let pattern1 = Factory.regex("ab+c")
let pattern2 = Factory.regex("xyz?")

let orPattern = pattern1.or(pattern2)
let andPattern = pattern1.and(pattern2)
let inversePattern = pattern1.inverse

```

### Printing complex patterns in easy-to-read steps 

```swift
let expression: Element = [.char(in: "<"),
                           .either([
                                .repeating(.charNot(in: "<>\"'"), times: .atLeastOnce),
                                [.quote, .repeating(.charNot(in: "\""), times: .any), .quote],
                                [.apostrophe, .repeating(.charNot(in: "'"), times: .any), .apostrophe]
                            ]),
                           .char(in: ">")
                          ]
print(expression.steps)

// prints
//  1) Left angle bracket
//  2) Match any one of:
//      2.1) Match one or more times:
//          2.1.1) Any character except left angle bracket, right angle bracket, double quotation mark or single quotation mark
//      2.2) Match sequence:
//          2.2.1) Double quotation mark
//          2.2.2) Match any number of times:
//              2.2.2.1) Any character except double quotation mark
//          2.2.3) Double quotation mark
//      2.3) Match sequence:
//          2.3.1) Single quotation mark
//      2.3.2) Match any number of times:
//          2.3.2.1) Any character except single quotation mark
//      2.3.3) Single quotation mark
//  3) Right angle bracket

```
