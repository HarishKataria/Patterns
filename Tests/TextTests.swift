//**************************************************************
//
//  TextTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class TextTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        return Factory.text("abc", matchCase: true)
    }

    func testText() {
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in: "abc"))
        XCTAssertFalse(pattern.hasMatches(in: "abbc"))
    }

    func testFirst() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.first(in: "1111abc"), "abc")
        XCTAssertNil(pattern.first(in: "acb"))
    }

    func testZeroFragments() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.fragments(of: "ac").count, 0)
    }

    func testOneFragment() {
        let input = "abc"
        let fragments = createPattern().fragments(of: input)

        XCTAssertEqual(fragments.count, 1)
        XCTAssertEqual(fragments[0].dataString, "abc")
    }

    func testThreeFragments() {
        let input = "-abc00ABC"
        let fragments = createPattern().fragments(of: input)

        XCTAssertEqual(fragments.count, 3)
        XCTAssertEqual(fragments[0].dataString, "-")
        XCTAssertEqual(fragments[1].dataString, "abc")

    }

    func testReplaceMatches() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "--abc--", to: "--"), "------")
        XCTAssertEqual(pattern.replaceMatches(in: "--abc--", to: "-$0_$1-"), "---abc_---")
        XCTAssertEqual(pattern.replaceMatches(in: "--abc--", to: pattern.escape(template: "$0_$1")), "--$0_$1--")
    }

    func testSplit() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.split("***abc---abc%%%"), [Substring("***"), Substring("---"), Substring("%%%")])
        XCTAssertEqual(pattern.split("***abc-X-abc%%%", configuredBy: SearchConfig(fragment: .text, maxMatches: 1)), [Substring("***")])
    }
}
