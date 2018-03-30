//**************************************************************
//
//  RegexpTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class RegexTests: XCTestCase {
    func testInvalidInputs() {
        XCTAssertNil(Regex(""))
        XCTAssertNil(Regex("[]"))
        XCTAssertNil(Regex("(ab"))
    }

    private func createPattern() -> Patterns.Pattern {
        return Factory.regex("a([b]+)c")
    }

    func testEscape() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.escape(template: "a $1 b"), "a \\$1 b")
        XCTAssertEqual(pattern.escape(template: "a 1 b"), "a 1 b")
        XCTAssertEqual(pattern.escape(template: "a $0 b"), "a \\$0 b")
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
        let fragments = createPattern().fragments(of: "ac")

        XCTAssertEqual(fragments.count, 0)
    }

    func testOneFragment() {
        let input = "abbc"
        let fragments = createPattern().fragments(of: input, configuredBy: .shallow)

        XCTAssertEqual(fragments.count, 1)
        XCTAssertEqual(fragments[0].dataString, "abbc")
    }

    func testSixFragments() {
        let input = "-abbc00abc"
        let fragments = createPattern().fragments(of: input, configuredBy: SearchConfig(fragment: .all))

        XCTAssertEqual(fragments.count, 6)
        XCTAssertEqual(fragments[0].dataString, "-")
        XCTAssertEqual(fragments[1].dataString, "abbc")
        XCTAssertEqual(fragments[2].dataString, "bb")
        XCTAssertEqual(fragments[3].dataString, "00")
        XCTAssertEqual(fragments[4].dataString, "abc")
        XCTAssertEqual(fragments[5].dataString, "b")
    }

    func testMatches() {
        let input = "-abbc00abc"
        let matches = createPattern().matches(in: input)

        XCTAssertEqual(matches.count, 2)
        XCTAssertEqual(matches[0].dataString, "abbc")
        XCTAssertEqual(matches[1].dataString, "abc")
    }

    func testFourFragments() {
        let input = "aabbc00abcabd"
        let fragments = createPattern().matches(in: input, configuredBy: SearchConfig(fragment: .all))

        XCTAssertEqual(fragments.count, 4)
        XCTAssertEqual(fragments[0].dataString, "abbc")
        XCTAssertEqual(fragments[1].dataString, "bb")
        XCTAssertEqual(fragments[2].dataString, "abc")
        XCTAssertEqual(fragments[3].dataString, "b")
    }

    func testTwoFragments() {
        let input = "aabbc00abcabd"
        let fragments = createPattern().matches(in: input, configuredBy: .firstMatch)

        XCTAssertEqual(fragments.count, 2)
        XCTAssertEqual(fragments[0].dataString, "abbc")
        XCTAssertEqual(fragments[1].dataString, "bb")
    }

    func testFourFragmentsMaxTwo() {
        let input = "aabbc00abcabdabbbc"
        let fragments = createPattern().matches(in: input, configuredBy: SearchConfig(fragment: .allMatch, maxMatches: 2))

        XCTAssertEqual(fragments.count, 4)
        XCTAssertEqual(fragments[0].dataString, "abbc")
        XCTAssertEqual(fragments[1].dataString, "bb")
    }

    func testReplaceMatches() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "--abc--", to: "--"), "------")
        XCTAssertEqual(pattern.replaceMatches(in: "--abbbc--", to: "-$0_$1-"), "---abbbc_bbb---")
        XCTAssertEqual(pattern.replaceMatches(in: "--abbbc--", to: pattern.escape(template: "$0_$1")), "--$0_$1--")
    }

    func testSplit() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.split("***abc---abbbc%%%"), [Substring("***"), Substring("---"), Substring("%%%")])
        XCTAssertEqual(pattern.split("***abc-*-abbbc%%%", configuredBy: SearchConfig(fragment: .text, maxMatches: 2)), [Substring("***"), Substring("-*-")])
        XCTAssertEqual(pattern.split("***abc-X-abbbc%%%", configuredBy: SearchConfig(fragment: .text, maxMatches: 1)), [Substring("***")])
    }
}
