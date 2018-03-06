//**************************************************************
//
//  AndPattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Joins an array of patterns in an AND boolean operation
 */
public struct AndPattern: Pattern {
    /** the array of patterns that are being joined in an AND operation */
    public let patterns: [Pattern]
}

public extension AndPattern {
    func locate(in target: String) -> StringRange? {
        var range: StringRange?
        for pattern in patterns {
            guard let result = pattern.locate(in: target) else {
                return nil
            }
            guard let previous = range else {
                range = result
                continue
            }
            if result.lowerBound < previous.lowerBound {
                range = result
            }
        }
        return range
    }

    func replaceMatches(in target: String, to template: String) -> String {
        guard hasMatches(in: target) else {
            return target
        }

        let result = patterns.reduce(target) { input, pattern in
            pattern.replaceMatches(in: input, to: pattern.escape(template: template))
        }
        return result
    }

    @discardableResult
    func iterate(over target: String,
                 configuredBy config: SearchConfig,
                 using block: (RangeFragment) -> Bool) -> MatchCount {
        guard hasMatches(in: target) else {
            if config.fragment.contains(.text) {
                _ = block(.text(target.startIndex..<target.endIndex))
            }
            return 0
        }
        return patterns.iterate(over: target, configuredBy: config, using: block)
    }
}
