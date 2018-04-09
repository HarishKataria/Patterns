//**************************************************************
//
//  Factory
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Factory for creating commonly used pattern types
 */
public extension Factory {
    /**
     * creates an empty matcher
     */
    static func empty() -> Pattern {
        return EmptyPattern()
    }

    /**
     * creates a regular expression pattern
     */
    static func regex(_ pattern: String, matchCase: Bool = false) -> Pattern {
        return Regex(pattern, matchCase: matchCase) ?? empty()
    }

    /**
     * creates a whole word matcher
     */
    static func word(_ word: String, matchCase: Bool = false) -> Pattern {
        let escaped = Regex.escape(pattern: word)
        return regex("\\b\(escaped)\\b", matchCase: matchCase)
    }

    /**
     * creates a prefix matcher
     */
    static func prefix(_ text: String, matchCase: Bool = false) -> Pattern {
        let escaped = Regex.escape(pattern: text)
        return regex("^\\s*\(escaped)", matchCase: matchCase)
    }

    /**
     * creates a suffix matcher
     */
    static func suffix(_ text: String, matchCase: Bool = false) -> Pattern {
        let escaped = Regex.escape(pattern: text)
        return regex("\(escaped)\\s*$", matchCase: matchCase)
    }

    /**
     * creates a plain text matcher
     */
    static func text(_ text: String, matchCase: Bool = false) -> Pattern {
        let escaped = Regex.escape(pattern: text)
        return regex(escaped, matchCase: matchCase)
    }

    internal static var glob: Element = {
        return .either([.capture(.char(in: "?")),
                        .capture(.char(in: "*")),
                        .capture([ .char(in: "["),
                                   .repeating(
                                    .either([ [.special(.slash), .any],
                                              .repeating(.charNot(in: "]"), times: .atLeastOnce)
                                        ]), times: .atLeastOnce),
                                   .char(in: "]")
                            ])
            ])
    }()

    /**
     * creates a wildcard (aka UNIX glob) pattern
     */
    static func wildcard(_ pattern: String, matchCase: Bool = false) -> Pattern {
        let patternObj = Builder.pattern(glob)
        guard let wildcard = patternObj else {
            return empty()
        }

        var globPattern = ""
        wildcard.fragments(of: pattern, configuredBy: .all).forEach { fragment in
            switch fragment {
            case .subMatch(_, let group) where group == 0:
                globPattern.append(".")

            case .subMatch(_, let group) where group == 1:
                globPattern.append(".*")

            case .subMatch(let data, let group) where group == 2:
                globPattern.append(String(data))

            case .text(let data):
                let esc = Regex.escape(pattern: String(data))
                globPattern.append(esc)

            case .match, .subMatch:
                break
            }
        }

        return regex(globPattern, matchCase: matchCase)
    }

    /**
     * creates a XCode-finder-like pattern
     */
    static func xcodeFilter(of input: String) -> Pattern {
        guard !input.isEmpty else {
            return empty()
        }
        let pattern = input.map { Regex.escape(pattern: String($0)) }.joined(separator: ").*(")
        return regex("(\(pattern))", matchCase: false)
    }
}

/**
 * A factory class that exposes the different patterns
 * that this library offers
 */
public final class Factory {
    private init() {
        /* empty type */
    }
}
