//**************************************************************
//
//  OrTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class OrTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        let r1 = Factory.regex("ab+c")
        let r2 = Factory.regex("xyz?")
        return [r1, r2].or
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in:"--abbbbbc..xy"))
        XCTAssertTrue(pattern.hasMatches(in:"eabcxycc"))
        XCTAssertFalse(pattern.hasMatches(in:"abxzy"))
    }

    func testReplace() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "cabccxyzc", to: "-"), "c-c-c")
    }
}
