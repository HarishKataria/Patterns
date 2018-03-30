//**************************************************************
//
//  WildCardTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class WildCardTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        return Factory.wildcard("ab*c")
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in: "abbc"))
        XCTAssertFalse(pattern.hasMatches(in: "ac"))
    }

    func testFirst() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.first(in: "abbc"), "abbc")
        XCTAssertNil(pattern.first(in: "acb"))
    }

    func testZeroFragments() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.fragments(of: "ac").count, 0)
    }

    func testOneFragments() {
        let input = "abbc"
        let fragments = createPattern().fragments(of: input)

        XCTAssertEqual(fragments.count, 1)
        XCTAssertEqual(fragments[0].dataString, "abbc")
    }

    func testTwoFragments() {
        let input = "-abbc00abc"
        let fragments = createPattern().fragments(of: input, configuredBy: SearchConfig(fragment: .all))

        XCTAssertEqual(fragments.count, 2)
        XCTAssertEqual(fragments[0].dataString, "-")
        XCTAssertEqual(fragments[1].dataString, "abbc00abc")
    }

    func testReplaceMatches() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "--abc--", to: "--"), "------")
        XCTAssertEqual(pattern.replaceMatches(in: "--abbbc--", to: "-$0_$1-"), "---abbbc_---")
        XCTAssertEqual(pattern.replaceMatches(in: "--abbbc--", to: pattern.escape(template: "$0_$1")), "--$0_$1--")
    }

    func testSplit() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.split("***abc---abbbc%%%"), [Substring("***"), Substring("%%%")])
        XCTAssertEqual(pattern.split("***abc-X-abbbc%%%", configuredBy: SearchConfig(fragment: .text, maxMatches: 1)), [Substring("***")])
    }
}
