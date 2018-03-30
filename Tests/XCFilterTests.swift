//**************************************************************
//
//  XCFilterTests
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import XCTest
import Patterns

final class XCFilterTests: XCTestCase {
    private func createPattern() -> Patterns.Pattern {
        return Factory.xcodeFilter(of: "crs")
    }

    func testHasMatches() {
        let pattern = createPattern()

        XCTAssertTrue(pattern.hasMatches(in: "XCFilterTests"))
        XCTAssertFalse(pattern.hasMatches(in: "cxscr"))
    }

    func testFirst() {
        let pattern = createPattern()

        XCTAssertEqual(pattern.first(in: "abcbrcrcsabc"), "cbrcrcs")
        XCTAssertNil(pattern.first(in: "cxscr"))
    }
}
