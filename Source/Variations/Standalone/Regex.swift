//**************************************************************
//
//  Regex
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * A pattern type that uses the NSRegularExpression engine
 */
public struct Regex: Pattern {
    private let regularExpression: ValueWrapper<NSRegularExpression>
}

public extension Regex {
    /**
     * initializer for common use-case of specifying only the case-sensitivity option
     */
    init?(_ pattern: String, matchCase: Bool) {
        self.init(pattern, options: !matchCase ? [.caseInsensitive] : [])
    }

    /**
     * initializer for full NSRegularExpression option set
     */
    init?(_ pattern: String, options: NSRegularExpression.Options = []) {
        guard pattern.count > 0,
              let template = try? NSRegularExpression(pattern: pattern, options: options),
              let value = ValueWrapper(template: template) else {
            return nil
        }
        regularExpression = value
    }
}

public extension Regex /* : MatchCollector */ {
    var supportsSubMatches: Bool {
        return true
    }
}

public extension Regex /* : RangeFinder */ {
    func locate(in target: String) -> StringRange? {
        guard let expression = regularExpression.value else {
            return nil
        }

        let match = expression.rangeOfFirstMatch(in: target, range: target.lengthRange)
        guard match.location != NSNotFound else {
            return nil
        }

        let start = target.index(target.startIndex, offsetBy: max(0, match.location))
        let end = target.index(start, offsetBy: max(0, match.length))
        return start..<end
    }
}

public extension Regex /* : MatchIterator */ {
    @discardableResult
    func iterate(over target: String,
                 configuredBy config: SearchConfig,
                 using block: (RangeFragment) -> Bool) -> MatchCount {
        guard let expression = regularExpression.value else {
            if config.fragment.contains(.text) {
                _ = block(.text(target.startIndex..<target.endIndex))
            }
            return 0
        }

        var marker = target.startIndex
        var matches = 0

        expression.enumerateMatches(in: target, options: [], range: target.lengthRange) { match, _, stopper in
            guard let match = match else {
                return
            }

            let result: Bool
            (result, marker) = iterate(on: match,
                                       from: target,
                                       anchoredAt: marker,
                                       configuredBy: config,
                                       using: block)
            matches += 1
            if !result || !config.allows(matchCount: matches + 1) {
                marker = target.endIndex
                stopper.pointee = true
            }
        }

        if matches > 0,
           marker < target.endIndex,
           config.fragment.contains(.text) {
            _ = block(.text(marker..<target.endIndex))
        }

        return matches
    }

    private func iterate(on match: NSTextCheckingResult,
                         from target: String,
                         anchoredAt marker: String.Index,
                         configuredBy config: SearchConfig,
                         using block: (RangeFragment) -> Bool) -> (Bool, String.Index) {
        let fragments = config.fragment

        let allowText = fragments.contains(.text)
        let allowMatch = fragments.contains(.match)
        let allowSubMatch = fragments.contains(.subMatch)

        var result = true
        var pos = marker

        for index in 0..<match.numberOfRanges {
            let matchRange = match.range(at: index)
            if matchRange.location == NSNotFound {
                continue
            }

            let start = target.index(target.startIndex, offsetBy: max(0, matchRange.location))
            let end = target.index(start, offsetBy: max(0, matchRange.length))

            if index == 0 {
                pos = end
                if allowText,
                   marker < start,
                   !block(.text(marker..<start)) {
                    result = false
                    break
                }
                if allowMatch,
                   !block(.match(start..<end)) {
                    result = false
                    break
                }
                if !allowSubMatch {
                    break
                }
            } else if allowSubMatch,
                !block(.subMatch(start..<end, id: index - 1)) {
                result = false
                break
            }
        }

        return (result, pos)
    }
}

public extension Regex /* : Replacer */ {
    func replaceMatches(in target: String, to template: String) -> String {
        guard let expression = regularExpression.value else {
            return template
        }

        let result = expression.stringByReplacingMatches(in: target,
                                                         options: [],
                                                         range: target.lengthRange,
                                                         withTemplate: template)
        return result
    }

    func escape(template: String) -> String {
        return NSRegularExpression.escapedTemplate(for: template)
    }

    var supportsReplaceTemplates: Bool {
        return true
    }
}

//**************************************************************
//                      supporting functions
//**************************************************************

extension Regex {
    private struct EscapePatternHolder {
        static let charPattern = Regex("[\\\\\\|\\^\\$\\(\\)\\{\\}\\*\\+\\?\\]\\[\\-]", matchCase: true)
    }

    /**
     * Escapes the special characters in the given string
     *
     * - pattern: the input string escape data from
     */
    public static func escape(pattern src: String) -> String {
        guard let pattern = EscapePatternHolder.charPattern else {
            return NSRegularExpression.escapedPattern(for: src)
        }
        let slashes = NSRegularExpression.escapedTemplate(for: "\\")
        return pattern.replaceMatches(in: src, to: "\(slashes)$0")
    }
}

extension String {
    internal var lengthRange: NSRange {
        return NSRange(location: 0, length: count)
    }
}
