//**************************************************************
//
//  OrPattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Joins an array of patterns in a OR boolean operation
 */
public struct OrPattern: Pattern {
    /** the array of patterns that are being joined in an OR operation */
    public let patterns: [Pattern]
}

public extension OrPattern {
    func locate(in target: String) -> StringRange? {
        return patterns.reduce(nil) { previous, pattern in
            guard let result = pattern.locate(in: target) else {
                return previous
            }

            if let previous = previous,
               previous.lowerBound <= result.lowerBound {
                return previous
            }
            return result
        }
    }

    func replaceMatches(in target: String, to template: String) -> String {
        return patterns.reduce(target) { input, pattern in
            pattern.replaceMatches(in: input, to: pattern.escape(template: template))
        }
    }

    @discardableResult
    func iterate(over target: String,
                 configuredBy config: SearchConfig,
                 using block: (RangeFragment) -> Bool) -> Int {
        return patterns.iterate(over: target, configuredBy: config, using: block)
    }
}
