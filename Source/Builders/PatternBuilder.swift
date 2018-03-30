//**************************************************************
//
//  Builder
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/** A Builder that composes a Pattern from a sequence of Elements */
public struct Builder {
    /** create a Pattern from the give sequence of Elements and initial configuration setting */
    public static func pattern(_ items: Element..., config: Element.Config = []) -> Pattern? {
        return Regex(items.patternString, options: config.options)
    }
}

extension Element: CustomStringConvertible {
    public var description: String {
        return patternString
    }
}

private extension Element {
    var patternString: String {
        switch self {
        case .firstInInput:
            return "\\A"

        case .lastInInput:
            return "\\z"

        case .newLine:
            return "(?:[\\r]?+[\\n])"

        case .endOfPreviousMatch:
            return "\\G"

        case .start:
            return "^"

        case .end:
            return "$"

        case .any:
            return "."

        case .skip:
            return ".*"

        case .space:
            return "\\s"

        case .spaces:
            return "\\s*"

        case .notSpace:
            return "\\S"

        case .digit:
            return "\\d"

        case .notDigit:
            return "\\D"

        case .word:
            return "\\w"

        case .words:
            return "\\w+"

        case .notWord:
            return "\\W"

        case .boundary:
            return "\\b"

        case .notBoundary:
            return "\\B"

        case .quote:
            return "\""

        case .apostrophe:
            return "'"

        case .backReference(let value):
            return "\\\(value+1)"

        case .special(let value):
            return value.patternString

        case .char(let value):
            let charsPattern = Regex.escape(pattern: value)
            return value.count == 1 ? charsPattern : "[\(charsPattern)]"

        case .charNot(let value):
            let charsPattern = Regex.escape(pattern: value)
            return "[^\(charsPattern)]"

        case .text(let value):
            return Regex.escape(pattern: value)

        case .repeating(let elem, let times):
            return "\(elem.patternStringUnit)\(times.patternString)"

        case .setConfig(let value):
            return value.onPatternString

        case .resetConfig(let value):
            return value.offPatternString

        case .capture(let value):
            return "(\(value.patternString))"

        case .either(let value):
            let content = value.map { $0.patternStringUnit }.joined(separator: "|")
            return value.count >= 2 ? "(?:\(content))" : content

        case .sequence(let value):
            return value.patternString

        case .section(let value):
            return "(?:\(value.patternString))"

        case .atomic(let value):
            return "(?>\(value.patternString))"

        case .lookAhead(let value):
            return "(?=\(value.patternString))"

        case .lookAheadInversed(let value):
            return "(?!\(value.patternString))"

        case .lookBehind(let value):
            return "(?<=\(value.patternString))"

        case .lookBehindInversed(let value):
            return "(?<!\(value.patternString))"
        }
    }

    var patternStringUnit: String {
        let value = patternString
        return weight > 1 ? "(?:\(value))" : value
    }
}

extension Element {
    var weight: Int {
        switch self {
        case .setConfig, .resetConfig:
            return 0

        case .start, .end, .firstInInput, .lastInInput,
             .backReference, .endOfPreviousMatch,
             .any, .boundary, .notBoundary,
             .newLine, .special,
             .quote, .apostrophe,
             .space, .notSpace, .digit, .notDigit,
             .word, .notWord, .char, .charNot:
            return 1

        case .capture, .section, .atomic, .either,
             .lookAhead, .lookAheadInversed,
             .lookBehind, .lookBehindInversed:
            return 1

        case .skip, .spaces, .repeating, .words:
            return 2

        case .text(let value):
            return value.count

        case .sequence(let value):
            return value.reduce(0) { $0 + $1.weight }
        }
    }
}

private extension Element.CollectionStatergy {
    var patternString: String {
        switch self {
        case .possessive:
            return "+"
        case .altruistic:
            return "?"
        }
    }
}

private extension Element.SpecialCharacter {
    var patternString: String {
        switch self {
        case .slash:                            return "\\\\"
        case .bell:                             return "\\a"
        case .backspace:                        return "\\u0008"
        case .escape:                           return "\\e"
        case .formfeed:                         return "\\f"
        case .tab:                              return "\\t"
        case .grapheme:                         return "\\X"
        case .control(let name):                return "\\c\(name)"
        case .hex(let num):                     return "\\x{\(String(num, radix: 16))}"
        case .named(let name):                  return "\\N{\(name)}"
        case .withUnicodeProperty(let name):    return "\\p{\(name)}"
        case .withoutUnicodeProperty(let name): return "\\P{\(name)}"
        }
    }
}

private extension Element.RepeatType {
    var patternString: String {
        switch self {
        case .atMostOnce:
            return "?"

        case .atLeastOnce:
            return "+"

        case .any:
            return "*"

        case .oneOrNone(let cs):
            return "?\(cs.patternString)"

        case .oneOrMore(let cs):
            return "+\(cs.patternString)"

        case .zeroOrMore(let cs):
            return "*\(cs.patternString)"

        case .extactly(let value):
            return "{\(value)}"

        case let .between(start, end):
            return "{\(start),\(end)}"

        case let .within(start, end, cs):
            return "{\(start),\(end)}\(cs.patternString)"

        case .atMost(let value):
            return "{,\(value)}"

        case .atLeast(let value):
            return "{\(value),}"

        case let .max(value, cs):
            return "{,\(value)}\(cs.patternString)"

        case let .min(value, cs):
            return "{\(value),}\(cs.patternString)"
        }
    }
}

private extension Element.Config {
    var onPatternString: String {
        var opts = ""
        if contains(.matchCase) { opts.append("(?-i)") }
        if contains(.anchorsMatchLines) { opts.append("(?m)") }
        if contains(.anyIncudesLineChars) { opts.append("(?s)") }
        if contains(.unicodeWordBoundries) { opts.append("(?w)") }
        return opts
    }

    var offPatternString: String {
        var opts = ""
        if contains(.matchCase) { opts.append("(?i)") }
        if contains(.anchorsMatchLines) { opts.append("(?-m)") }
        if contains(.anyIncudesLineChars) { opts.append("(?-s)") }
        if contains(.unicodeWordBoundries) { opts.append("(?-w)") }
        return opts
    }

    var options: NSRegularExpression.Options {
        var options: NSRegularExpression.Options = []
        if !contains(.matchCase) { options.formUnion(.caseInsensitive) }
        if contains(.anchorsMatchLines) { options.formUnion(.anchorsMatchLines) }
        if contains(.anyIncudesLineChars) { options.formUnion(.dotMatchesLineSeparators) }
        if contains(.unicodeWordBoundries) { options.formUnion(.useUnicodeWordBoundaries) }
        return options
    }
}

private extension Array where Element == Patterns.Element {
    var patternString: String {
        return map { $0.patternString }.joined(separator: "")
    }
}
