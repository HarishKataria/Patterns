//**************************************************************
//
//  Pattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * This framework's main protocol, Pattern, consolidates various aspects
 * of a matcher. The protocol adds the ability to combine,
 * via boolean-logic operators, sub-types for building even more complex
 * matching bahaviors.
 */
public protocol Pattern: MatchChecker,
                         RangeFinder, SubstringFinder,
                         MatchCollector, MatchIterator,
                         Fragmenter, Splitter,
                         Replacer {
    /**
     * inverts the matching bahavior
     */
    var inverse: Pattern { get }

    /**
     * joins with another pattern for a Boolean AND operation
     */
    func and(_: Pattern) -> Pattern

    /**
     * joins with another pattern for a Boolean OR operation
     */
    func or(_: Pattern) -> Pattern
}
