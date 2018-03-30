//**************************************************************
//
//  PrefixTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class PrefixTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        return Factory.prefix("abc", matchCase: true)
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in: "abc"))
        XCTAssertFalse(pattern.hasMatches(in: "abbc"))
        XCTAssertFalse(pattern.hasMatches(in: "aabcc"))
    }

    func testFirst() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.first(in: "abc111abc"), "abc")
        XCTAssertNil(pattern.first(in: " .abc"))
    }

    func testZeroFragments() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.fragments(of: "ac").count, 0)
    }

    func testOneFragment() {
        let input = "abc"
        let pattern = createPattern()

        let fragments = pattern.fragments(of: input)
        XCTAssertEqual(fragments.count, 1)
        XCTAssertEqual(fragments[0].dataString, "abc")
    }

    func testTwoFragments() {
        let input = "abc-00ABC"
        let pattern = createPattern()

        let fragments = pattern.fragments(of: input)
        XCTAssertEqual(fragments.count, 2)
        XCTAssertEqual(fragments[0].dataString, "abc")
        XCTAssertEqual(fragments[1].dataString, "-00ABC")
    }

    func testReplaceMatches() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "abc--", to: "--"), "----")
        XCTAssertEqual(pattern.replaceMatches(in: "abc--", to: "-$0_$1-"), "-abc_---")
        XCTAssertEqual(pattern.replaceMatches(in: "abc--", to: pattern.escape(template: "$0_$1")), "$0_$1--")
    }

    func testSplit() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.split("abc---abc%%%"), [Substring("---abc%%%")])
    }
}
