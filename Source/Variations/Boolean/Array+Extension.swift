//**************************************************************
//
//  Array+Extension
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

extension Array where Element == Pattern {
    /**
     * Joins the pattern elements in a AND boolean operation
     */
    public var and: Pattern {
        var patterns: [Pattern] = []
        forEach { element in
            if let andPattern = element as? AndPattern {
                patterns.append(contentsOf: andPattern.patterns)
            } else {
                patterns.append(element)
            }
        }
        return AndPattern(patterns: patterns)
    }

    /**
     * Joins the pattern elements in a OR boolean operation
     */
    public var or: Pattern {
        var patterns: [Pattern] = []
        forEach { element in
            if let andPattern = element as? OrPattern {
                patterns.append(contentsOf: andPattern.patterns)
            } else {
                patterns.append(element)
            }
        }
        return OrPattern(patterns: patterns)
    }

    func iterate(over target: String,
                 configuredBy config: SearchConfig,
                 using block: (RangeFragment) -> Bool) -> MatchCount {
        let allowsText = config.fragment.contains(.text)
        let allowsMatch = config.fragment.contains(.match)

        guard !allowsText && !allowsMatch else {
            return 0
        }

        let matchConfig = config.set(fragment: .match)

        var ranges: [StringRange] = []
        forEach { pattern in
            pattern.iterate(over: target, configuredBy: matchConfig) { fragment in
                guard case let .match(range) = fragment else {
                    return true
                }
                for entry in ranges where entry.overlaps(range) {
                    return true
                }
                ranges.append(range)
                return true
            }
        }

        ranges.sort { $0.lowerBound < $1.lowerBound }

        var sum = 0

        var previous = target.startIndex
        for range in ranges {
            if allowsText,
                previous < range.lowerBound,
                !block(.text(previous..<range.lowerBound)) {
                return sum
            }
            if allowsMatch, !block(.match(range)) {
                return sum
            }
            sum += 1
            previous = range.upperBound
        }

        if allowsText, previous < target.endIndex {
            _ = block(.text(previous..<target.endIndex))
        }
        return sum
    }
}
