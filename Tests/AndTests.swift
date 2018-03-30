//**************************************************************
//
//  AndTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class AndTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        let r1 = Factory.regex("ab+c")
        let r2 = Factory.regex("xyz?")
        return [r1, r2].and
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertFalse(pattern.hasMatches(in: "--abbbbbc..xcy"))
        XCTAssertFalse(pattern.hasMatches(in: "eabxyzcc"))
        XCTAssertTrue(pattern.hasMatches(in: ".865abbc2132xyz121"))
    }

    func testReplace() {
        let input = "cabccxyzc"
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in: input))
        XCTAssertEqual(pattern.replaceMatches(in: input, to: "-"), "c-c-c")
    }
}
