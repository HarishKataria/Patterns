//**************************************************************
//
//  Behavior Extensions
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**************** RangeFinder based extensions ********************/

public extension MatchChecker where Self: RangeFinder {
    func hasMatches(in target: String) -> Bool {
        return locate(in: target) != nil
    }
}

public extension SubstringFinder where Self: RangeFinder {
    func first(in target: String) -> Substring? {
        guard let range = locate(in: target) else {
            return nil
        }
        return target[range]
    }
}

/**************** MatchIterator based extensions ********************/

fileprivate extension MatchIterator {
    func collectSubstrings(in target: String, configuredBy config: SearchConfig) -> [SubstringFragment] {
        var result: [SubstringFragment] = []
        iterate(over: target, configuredBy: config) { fragment in
            result.append(fragment.map { target[$0] })
            return true
        }
        return result
    }

    func collectRanges(in target: String, configuredBy config: SearchConfig) -> [RangeFragment] {
        var result: [RangeFragment] = []
        let matchConfig = config.remove(fragment: .text)
        iterate(over: target, configuredBy: matchConfig) { fragment in
            result.append(fragment)
            return true
        }
        return result
    }
}

public extension MatchCollector where Self: MatchIterator {
    func matches(in target: String, configuredBy config: SearchConfig) -> [SubstringFragment] {
        let matchConfig = config.remove(fragment: .text)
        return collectSubstrings(in: target, configuredBy: matchConfig)
    }

    func matchRanges(in target: String, configuredBy config: SearchConfig) -> [RangeFragment] {
        let matchConfig = config.remove(fragment: .text)
        return collectRanges(in: target, configuredBy: matchConfig)
    }
}

public extension Fragmenter where Self: MatchIterator {
    func fragments(of target: String, configuredBy config: SearchConfig) -> [SubstringFragment] {
        return collectSubstrings(in: target, configuredBy: config)
    }
}

public extension Splitter where Self: MatchIterator {
    func split(_ target: String, configuredBy config: SearchConfig) -> [Substring] {
        var result: [Substring] = []
        let matchConfig = config.set(fragment: .text)
        iterate(over: target, configuredBy: matchConfig) { fragment in
            guard case let .text(data) = fragment else {
                return true
            }
            result.append(target[data])
            return true
        }
        return result
    }
}

/**************** Default implementation ********************/

public extension MatchCollector {
    func matches(in target: String) -> [SubstringFragment] {
        return matches(in: target, configuredBy: .matches)
    }

    func matchRanges(in target: String) -> [RangeFragment] {
        return matchRanges(in: target, configuredBy: .matches)
    }

    /**
     * true if the type supports matches within matched regions
     */
    var supportsSubMatches: Bool {
        return false
    }
}

public extension Replacer {
    func escape(template: String) -> String {
        return template
    }

    /**
     * true if this pattern type supports templates
     */
    var supportsReplaceTemplates: Bool {
        return false
    }
}

public extension MatchIterator {
    @discardableResult
    func iterate(over target: String,
                 using block: (RangeFragment) -> Bool) -> MatchCount {
        return iterate(over: target, configuredBy: .all, using: block)
    }
}

public extension Fragmenter {
    func fragments(of target: String) -> [SubstringFragment] {
        return fragments(of: target, configuredBy: .all)
    }
}

public extension Splitter {
    func split(_ target: String) -> [Substring] {
        return split(target, configuredBy: .text)
    }
}
