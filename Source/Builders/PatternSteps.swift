//**************************************************************
//
//  Steps
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public extension Element {
    /** describes the pattern in steps of easy to read sentences */
    var steps: String {
        return print(context: SharedGroupPrintContext())
    }
}

private protocol PrintContext {
    var index: Int { get }
    var prefix: String { get }

    func set(prefix newPrefix: String) -> PrintContext
    func nextIndex() -> PrintContext
    func nextGroup() -> Int
}

private extension Element {
    // swiftlint:disable cyclomatic_complexity function_body_length
    func print(context: PrintContext) -> String {
        switch self {
        case .firstInInput:
            return "First character of the input"

        case .lastInInput:
            return "Last character of the input"

        case .newLine:
            return "New line"

        case .endOfPreviousMatch:
            return "End of previous match"

        case .start:
            return "First character of line"

        case .end:
            return "Last character of line"

        case .any:
            return "Any one character"

        case .skip:
            return "Any character sequence"

        case .space:
            return "Space"

        case .spaces:
            return "Multiple spaces"

        case .notSpace:
            return "Non-space character"

        case .digit:
            return "Digit"

        case .notDigit:
            return "Non-digit"

        case .word:
            return "Letter"

        case .words:
            return "Sequence of letters"

        case .notWord:
            return "Non-letter"

        case .boundary:
            return "Word boundary"

        case .notBoundary:
            return "Non-word boundary"

        case .quote:
            return "Double quotation mark"

        case .apostrophe:
            return "Single quotation mark"

        case .backReference(let value):
            return "Previous match #\(value+1)"

        case .special(let value):
            return value.readable

        case .char(let value):
            guard value.count > 0 else {
                return ""
            }
            guard value.count > 1 else {
                return value.readable
            }

            var items = value
            let last = String(items.removeLast()).readable.lowercased()
            let prefix = items.map { String($0).readable.lowercased() }.joined(separator: ", ")
            let entries = "\(prefix) or \(last)"
            return entries

        case .charNot(let value):
            guard value.count > 0 else {
                return ""
            }
            guard value.count > 1 else {
                return "Any character except \(value.readable.lowercased())"
            }

            var items = value
            let last = String(items.removeLast()).readable.lowercased()
            let prefix = items.map { String($0).readable.lowercased() }.joined(separator: ", ")
            let entries = "\(prefix) or \(last)"
            return "Any character except \(entries)"

        case .text(let value):
            return value

        case .setConfig(let value):
            return value.readableOnOptions

        case .resetConfig(let value):
            return value.readableOffOptions

        case .repeating(let value, let times):
            let printChildren = print(children: [value], context: context)
            return "\(times.readable)\(printChildren)"

        case .capture(let value):
            let group = context.nextGroup()
            let printChildren = print(children: [value], context: context)
            return "Match and capture #(\(group)\(printChildren)"

        case .either(let value):
            let printChildren = print(children: value, context: context)
            return "Match any one of\(printChildren)"

        case .sequence(let value):
            let printChildren = print(children: value, context: context)
            return "Match sequence\(printChildren)"

        case .section(let value):
            let printChildren = print(children: [value], context: context)
            return "Match sequence\(printChildren)"

        case .atomic(let value):
            let printChildren = print(children: [value], context: context)
            return "Match whole or none of pattern\(printChildren)"

        case .lookAhead(let value):
            let printChildren = print(children: [value], context: context)
            return "Look ahead pattern\(printChildren)"

        case .lookAheadInversed(let value):
            let printChildren = print(children: [value], context: context)
            return "Look ahead pattern not to match\(printChildren)"

        case .lookBehind(let value):
            let printChildren = print(children: [value], context: context)
            return "Look behind for pattern\(printChildren)"

        case .lookBehindInversed(let value):
            let printChildren = print(children: [value], context: context)
            return "Look behind for pattern not to match\(printChildren)"
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length

    func print(children: [Element], context: PrintContext) -> String {
        let tabs = String(repeating: "\t", count: context.index)
        let baseContext = context.nextIndex()

        var result = ":"
        var index = 1
        children.forEach { item in
            let childPrefix = context.prefix.isEmpty ? String(index) : "\(context.prefix).\(index)"
            result.append("\n\(tabs)\(childPrefix)) ")
            result.append(item.print(context: baseContext.set(prefix: childPrefix)))
            index += 1
        }
        return result
    }
}

private extension String {
    var readable: String {
        switch self {
        case " ":   return "Space"
        case "\t":  return "Tab"
        case "\r":  return "Carriage return"
        case "\n":  return "New-line"
        case "\\":  return "Slash"
        case "/":   return "Forward slash"
        case "`":   return "Apostrophe"
        case "\"":  return "Double quotation mark"
        case "'":   return "Single quotation mark"
        case ".":   return "Period"
        case ",":   return "Comma"
        case ";":   return "Semicolon"
        case ":":   return "Colon"
        case "?":   return "Question mark"
        case "*":   return "Star"
        case "+":   return "Plus"
        case "(":   return "Left parenthesis"
        case ")":   return "Right parenthesis"
        case "[":   return "Left square bracket"
        case "]":   return "Right square bracket"
        case "<":   return "Left angle bracket"
        case ">":   return "Right angle bracket"
        default:    return self
        }
    }
}

private extension Element.SpecialCharacter {
    var readable: String {
        switch self {
        case .slash:                            return "Slash"
        case .bell:                             return "Bell"
        case .backspace:                        return "Backspace"
        case .escape:                           return "Escape"
        case .formfeed:                         return "Formfeed"
        case .tab:                              return "Tab"
        case .grapheme:                         return "Grapheme"
        case .control(let name):                return "Control character \(name)"
        case .hex(let num):                     return "Character \(String(num, radix: 16))"
        case .named(let name):                  return "Unicode character named \(name)"
        case .withUnicodeProperty(let name):    return "Unicode character with property \(name)"
        case .withoutUnicodeProperty(let name): return "Unicode character without property \(name)"
        }
    }
}

private extension Element.CollectionStatergy {
    var readable: String {
        switch self {
        case .possessive: return "preferring as many as possible"
        case .altruistic: return "preferring as few as possible"
        }
    }

    var shortReadable: String {
        switch self {
        case .possessive: return "preferring once"
        case .altruistic: return "preferring none"
        }
    }
}

private extension Element.RepeatType {
    var readable: String {
        switch self {
        case .atMostOnce:
            return "Match at most once"

        case .atLeastOnce:
            return "Match one or more times"

        case .any:
            return "Match any number of times"

        case .oneOrNone(let statergy):
            return "Match at most once, \(statergy.shortReadable)"

        case .oneOrMore(let statergy):
            return "Match one or more times, \(statergy.readable)"

        case .zeroOrMore(let statergy):
            return "Match any number of times, \(statergy.readable)"

        case .extactly(let value):
            return "Match extactly \(value) times"

        case let .between(start, end):
            return "Match between \(start) and \(end) times"

        case let .within(start, end, statergy):
            return "Match between \(start) and \(end) times, \(statergy.readable)"

        case .atMost(let value):
            return "Match at most \(value) times"

        case .atLeast(let value):
            return "Match at least \(value) times"

        case let .max(value, statergy):
            return "Match at most \(value) times, \(statergy.readable)"

        case let .min(value, statergy):
            return "Match at least \(value) times, \(statergy.readable)"
        }
    }
}

private extension Element.Config {
    var readableOnOptions: String {
        var opts: [String] = []
        if contains(.matchCase) { opts.append("match case") }
        if contains(.anchorsMatchLines) { opts.append("match anchors to line boundries") }
        if contains(.anyIncudesLineChars) { opts.append("exclude line characters when matching any") }
        if contains(.unicodeWordBoundries) { opts.append("use ascii word boundries") }
        return "Set options: \(opts.joined(separator: ", "))"
    }

    var readableOffOptions: String {
        var opts: [String] = []
        if contains(.matchCase) { opts.append("do not match case") }
        if contains(.anchorsMatchLines) { opts.append("match anchors to input boundries") }
        if contains(.anyIncudesLineChars) { opts.append("include line characters when matching any") }
        if contains(.unicodeWordBoundries) { opts.append("use unicode word boundries") }
        return "Set options: \(opts.joined(separator: ", "))"
    }
}

private final class SharedGroupPrintContext {
    private let group: Group
    let index: Int
    let prefix: String

    init(group: Group = Group(), index: Int = 1, prefix: String = "") {
        self.group = group
        self.index = index
        self.prefix = prefix
    }
}

private extension SharedGroupPrintContext {
    final class Group {
        var index: Int

        init(index: Int = 1) {
            self.index = index
        }

        func next() -> Int {
            let last = index
            index = last + 1
            return last
        }
    }
}

extension SharedGroupPrintContext: PrintContext {
    func set(prefix newPrefix: String) -> PrintContext {
        return SharedGroupPrintContext(group: group, index: index, prefix: newPrefix)
    }

    func nextIndex() -> PrintContext {
        return SharedGroupPrintContext(group: group, index: index+1, prefix: prefix)
    }

    func nextGroup() -> Int {
        return group.next()
    }
}
