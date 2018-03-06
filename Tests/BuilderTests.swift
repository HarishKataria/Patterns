//**************************************************************
//
//  BuilderTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
@testable import Patterns

final class BuilderTests: XCTestCase {
    func testComplex() {
        let expressionObj: Element
        let expressionStr: String

        expressionStr = "^\\s*(?:(?:[abc]{1,}+)|(?=\\w+)).*$"
        expressionObj = [.start, .spaces,
                         .either([.repeating(.char(in: "abc"), times: .min(1, .possessive)),
                                  .lookAhead(.repeating(.word, times: .atLeastOnce))]),
                         .repeating(.any, times: .any), .end]

        XCTAssertEqual(expressionObj.description, expressionStr)
    }

    func testTag() {
        let expressionObj: Element
        let expressionStr: String

        expressionStr = "<(?:(?:[^<>\"']+)|(?:\"[^\"]*\")|(?:'[^']*'))>"
        expressionObj = [.char(in: "<"),
                         .either([
                            .repeating(.charNot(in: "<>\"'"), times: .atLeastOnce),
                            [.quote, .repeating(.charNot(in: "\""), times: .any), .quote],
                            [.apostrophe, .repeating(.charNot(in: "'"), times: .any), .apostrophe]
                            ]),
                         .char(in: ">")]

        XCTAssertEqual(expressionObj.description, expressionStr)
    }

    func testWildCard() {
        let expressionObj: Element
        let expressionStr: String

        expressionStr = "(?:(\\?)|(\\*)|(\\[(?:(?:\\\\.)|(?:[^\\]]+))+\\]))"
        expressionObj = Factory.glob
        XCTAssertEqual(expressionObj.description, expressionStr)
    }
}
