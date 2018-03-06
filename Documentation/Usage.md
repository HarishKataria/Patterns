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
