//**************************************************************
//
//  InverseTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class InverseTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        return Factory.regex("ab+c").inverse
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertFalse(pattern.hasMatches(in:"abbbbbc"))
        XCTAssertTrue(pattern.hasMatches(in:"abxcc"))
        XCTAssertTrue(pattern.hasMatches(in:"cabccc"))
    }

    func testReplace() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.replaceMatches(in: "cabccc", to: "-"), "-abc-")
    }
}
