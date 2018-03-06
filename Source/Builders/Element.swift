//**************************************************************
//
//  RegexElement
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Elements are components used to build Pattern
 */
public indirect enum Element {

    /*------------------ character classes ------------------*/

    /** any character */
    case any

    /** space characters */
    case space
    /** characters except spaces */
    case notSpace

    /** characters from '0' to '9'  */
    case digit
    /** characters except '0' to '9' */
    case notDigit

    /** character 'a' to 'z' */
    case word
    /** characters except 'a' to 'z' */
    case notWord

    /** characters '\n', '\r', or '\r\n' */
    case newLine

    /** character '"' */
    case quote
    /** character "'" */
    case apostrophe

    /*------------------ character groups ------------------*/

    /** character groups to match from */
    case char(in: String)
    /** character groups to not match from */
    case charNot(in: String)

    /*------------------ esoteric characters ---------------*/

    /** special characters */
    case special(SpecialCharacter)

    /*------------------ position anchors ------------------*/

    /** start character of the current line */
    case start
    /** end character of the current line */
    case end

    /** first character of the input anchor */
    case firstInInput
    /** last character of the input anchor */
    case lastInInput

    /** word and non-word boundary */
    case boundary
    /** not at the boundary word and non-word characters */
    case notBoundary

    /*------------------ match references ------------------*/

    /** match the same sequence as the last captured group */
    case endOfPreviousMatch
    /** match the same sequence as a previously captured group */
    case backReference(withId: SubMatchIdentifier)

    /*------------------ exact match -----------------------*/

    /** plain text */
    case text(String)

    /*------------------ operations ------------------------*/

    /** repeat the given element with given times */
    case repeating(Element, times: RepeatType)
    /** match any one of the sequence elements */
    case either([Element])

    /*------------------ grouping --------------------------*/

    /** a simple sequence of elements */
    case sequence([Element])

    /** a sequence of elements to be treated like a element for operations */
    case section(Element)
    /** a sequence of elements that is captured a group */
    case capture(Element)
    /** a sequence of elements to match atomically */
    case atomic(Element)

    /*------------------ match assertions -----------------*/

    /** Zero-width lookahead assertion */
    case lookAhead(Element)
    /** Zero-width negative lookahead assertion */
    case lookAheadInversed(Element)

    /** Zero-width lookbehind assertion */
    case lookBehind(Element)
    /** Zero-width negative lookbehind assertion */
    case lookBehindInversed(Element)

    /*------------------ commonly used fragments -----------*/

    /** fragment for skip any number of any characters */
    case skip
    /** any number of space characters */
    case spaces
    /** any number of word characters */
    case words

    /*------------------ configure -----------------------*/

    /** set the given config settings */
    case setConfig(Config)
    /** reset the given config settings */
    case resetConfig(Config)
}

extension Element: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self = .sequence(elements)
    }
}

extension Element {
    /** characters specially handled by the matcher */
    public enum SpecialCharacter {
        /** '\\' */
        case slash
        /** '\b' */
        case bell
        /** backspace character */
        case backspace
        /** escape character */
        case escape
        /** '\f' */
        case formfeed
        /** '\t' */
        case tab
        /** grapheme character */
        case grapheme

        /** character from control group  */
        case control(String)
        /** character by hex value */
        case hex(Int)

        /** named unicode character */
        case named(String)
        /** named unicode characters with given property */
        case withUnicodeProperty(String)
        /** named unicode characters without given property */
        case withoutUnicodeProperty(String)
    }

    /** Types of reating functions */
    public enum RepeatType {
        /** At Most Once. Same as Regular Expression '+'. */
        case atMostOnce
        /** At Least Once. Same as Regular Expression '?' */
        case atLeastOnce
        /** Any number of times. Same as Regular Expression '*' */
        case any

        /** At most 'n' times */
        case atMost(Int)
        /** At Least 'n' times */
        case atLeast(Int)
        /**  extactly 'n' times */
        case extactly(Int)
        /**  within a range of a minimum and a maximum count */
        case between(Int, Int)

        /**  one or none times, driven by a collection statergy */
        case oneOrNone(CollectionStatergy)
        /**  one or more times, driven by a collection statergy */
        case oneOrMore(CollectionStatergy)
        /**  zero or more times, driven by a collection statergy */
        case zeroOrMore(CollectionStatergy)

        /** repeat at most 'n' times, driven by a collection statergy */
        case max(Int, CollectionStatergy)
        /** repeat at least 'n' times, driven by a collection statergy */
        case min(Int, CollectionStatergy)
        /** repeat between the range, driven by a collection statergy */
        case within(Int, Int, CollectionStatergy)
    }

    /** Statergy enumeration for how data elements should be gathered */
    public enum CollectionStatergy {
        /** collect as many as possible */
        case possessive
        /** collect as few as possible */
        case altruistic
    }

    /** Settings used to configure the match behavior */
    public struct Config: OptionSet {
        /** match characters of same case */
        public static let matchCase                 = Config(type: 0)
        /** enables anchors to match boundaries on each line */
        public static let anchorsMatchLines         = Config(type: 1)
        /** 'any' element incudes line characters */
        public static let anyIncudesLineChars       = Config(type: 2)
        /** use unicode word boundries instead of ASCII */
        public static let unicodeWordBoundries      = Config(type: 3)

        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
