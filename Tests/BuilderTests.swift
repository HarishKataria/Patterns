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

    func testSteps() {
        let expressionObj: Element = [.char(in: "<"),
                         .either([
                            .repeating(.charNot(in: "<>\"'"), times: .atLeastOnce),
                            [.quote, .repeating(.charNot(in: "\""), times: .any), .quote],
                            [.apostrophe, .repeating(.charNot(in: "'"), times: .any), .apostrophe]
                            ]),
                         .char(in: ">")]
        let steps = """
            Match sequence:
            \t1) Left angle bracket
            \t2) Match any one of:
            \t\t2.1) Match one or more times:
            \t\t\t2.1.1) Any character except left angle bracket, right angle bracket, double quotation mark or single quotation mark
            \t\t2.2) Match sequence:
            \t\t\t2.2.1) Double quotation mark
            \t\t\t2.2.2) Match any number of times:
            \t\t\t\t2.2.2.1) Any character except double quotation mark
            \t\t\t2.2.3) Double quotation mark
            \t\t2.3) Match sequence:
            \t\t\t2.3.1) Single quotation mark
            \t\t\t2.3.2) Match any number of times:
            \t\t\t\t2.3.2.1) Any character except single quotation mark
            \t\t\t2.3.3) Single quotation mark
            \t3) Right angle bracket
            """
        XCTAssertEqual(expressionObj.steps, steps)
    }

    func testWildCard() {
        let expressionObj: Element
        let expressionStr: String

        expressionStr = "(?:(\\?)|(\\*)|(\\[(?:(?:\\\\.)|(?:[^\\]]+))+\\]))"
        expressionObj = Factory.glob
        XCTAssertEqual(expressionObj.description, expressionStr)
    }
}
