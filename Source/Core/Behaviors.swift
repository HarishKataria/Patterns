//**************************************************************
//
//  Behaviors
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Marker protocol for match behaviors
 */
public protocol MatchBehavior {
}

/**
 * The simplest matcher -- one that finds if the match exists or not
 */
public protocol MatchChecker: MatchBehavior {
    /**
     * returns true if pattern exits in the given string
     */
    func hasMatches(in: String) -> Bool
}

/**
 * The matcher that can find the location of the match
 */
public protocol RangeFinder: MatchBehavior {
    /**
     * finds the location and size of the match in the given string
     */
    func locate(in: String) -> StringRange?
}

/**
 * A utility variation of RangeFinder, that returns Substring value instead of range
 */
public protocol SubstringFinder: MatchBehavior {
    /**
     * get the first match as a substring
     */
    func first(in: String) -> Substring?
}

/**
 * A pattern type that can breakdown a string into matches, sub-matches,
 * and unmatched fragments
 */
public protocol Fragmenter: MatchBehavior {
    /**
     * breakdown the input string into an array of fragments
     */
    func fragments(of: String) -> [SubstringFragment]

    /**
     * breakdown the input string to a specific configuration
     */
    func fragments(of: String, configuredBy: SearchConfig) -> [SubstringFragment]
}

/**
 * Matcher that can find multiple match instances
 */
public protocol MatchCollector: MatchBehavior {
    /**
     * gets all the matches
     */
    func matches(in: String) -> [SubstringFragment]

    /**
     * gets all the matches filtered to a configuration
     */
    func matches(in: String, configuredBy: SearchConfig) -> [SubstringFragment]

    /**
     * gets all the match ranges
     */
    func matchRanges(in: String) -> [RangeFragment]

    /**
     * gets all the match ranges filtered by the given configuration
     */
    func matchRanges(in: String, configuredBy: SearchConfig) -> [RangeFragment]

    /**
     * true if the type supports matches within matched regions
     */
    var supportsSubMatches: Bool { get }
}

/**
 * Matcher that specializes in breaking string value into substring values
 */
public protocol Splitter: MatchBehavior {
    /**
     * gets an array of substring divided by the matches
     */
    func split(_: String) -> [Substring]

    /**
     * gets array of substring divided by the matches filtered by the configuration
     */
    func split(_: String, configuredBy: SearchConfig) -> [Substring]
}

/**
 * An iterator type to traverse the string fragments, both match and unmatched elements
 */
public protocol MatchIterator: MatchBehavior {
    /**
     * iterates over the given string using the given closure
     */
    @discardableResult func iterate(over: String, using: (RangeFragment) -> Bool) -> MatchCount

    /**
     * iterates over the given string using the given closure with a specific configuration
     */
    @discardableResult func iterate(over: String, configuredBy: SearchConfig, using: (RangeFragment) -> Bool) -> MatchCount
}

/**
 * Matcher that can transform strings by replacing matched areas
 */
public protocol Replacer: MatchBehavior {
    /**
     * replace matches from the input with the given template
     */
    func replaceMatches(in: String, to: String) -> String

    /**
     * true if this pattern type supports templates
     */
    var supportsReplaceTemplates: Bool { get }

    /**
     * escape the template pattern
     */
    func escape(template: String) -> String
}
