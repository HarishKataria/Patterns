//**************************************************************
//
//  EmptyPattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * A pattern that matches nothing
 */
struct EmptyPattern: Pattern {
    func locate(in _: String) -> StringRange? {
        return nil
    }

    @discardableResult func iterate(over target: String,
                                    configuredBy config: SearchConfig,
                                    using block: (RangeFragment) -> Bool) -> MatchCount {
        if config.fragment.contains(.text) {
            _ = block(.text(target.startIndex..<target.endIndex))
        }
        return 0
    }

    func replaceMatches(in target: String, to _: String) -> String {
        return target
    }

    var inverse: Pattern {
        return AllPattern()
    }

    func and(_ other: Pattern) -> Pattern {
        return self
    }

    func or(_ other: Pattern) -> Pattern {
        return other
    }
}

/**
 * A pattern that matches everything (inverse of EmptyPattern)
 */
private struct AllPattern: Pattern {
    func locate(in target: String) -> StringRange? {
        return target.startIndex..<target.endIndex
    }

    @discardableResult func iterate(over target: String,
                                    configuredBy config: SearchConfig,
                                    using block: (RangeFragment) -> Bool) -> MatchCount {
        if config.fragment.contains(.match) {
            _ = block(.match(target.startIndex..<target.endIndex))
            return 1
        }
        return 0
    }

    func replaceMatches(in _: String, to template: String) -> String {
        return template
    }

    var inverse: Pattern {
        return EmptyPattern()
    }

    func and(_ other: Pattern) -> Pattern {
        return other
    }

    func or(_: Pattern) -> Pattern {
        return self
    }
}
