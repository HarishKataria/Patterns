//**************************************************************
//
//  Globals
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Match count as interger values
 */
public typealias MatchCount = Int

/**
 * Submatch identifier as integer values
 */
public typealias SubMatchIdentifier = Int

/**
 * Range with string indexes
 */
public typealias StringRange = Range<String.Index>

/**
 * Fragment based on range values
 */
public typealias RangeFragment = Fragment<StringRange>

/**
 * Fragment based on substring values
 */
public typealias SubstringFragment = Fragment<Substring>

/**
 * Add support for using MatchChecker type support in `case` expressions
 */
public func ~= (pattern: MatchChecker, value: String) -> Bool {
    return pattern.hasMatches(in: value)
}

/**
 * Extension for Integer-based OptionSet
 */
extension RawRepresentable where RawValue == Int, Self: OptionSet {
    /**
     * encapsulate the code to build bit value for each OptionSet element
     */
    public init(type: Int) {
        self.init(rawValue: 1 << max(type, 0))
    }
}
