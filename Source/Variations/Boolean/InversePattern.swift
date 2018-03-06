//**************************************************************
//
//  InversePattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * A pattern wrapper to give inverse match results
 */
public struct InversePattern: Pattern {
    /** the source pattern */
    public let source: Pattern
}

public extension InversePattern {
    func locate(in target: String) -> StringRange? {
        guard let range = source.locate(in: target) else {
            return target.startIndex..<target.endIndex
        }

        if target.startIndex < range.lowerBound {
            return target.startIndex..<range.lowerBound
        }

        if target.endIndex == range.upperBound {
            return nil
        }

        let rest = String(target[range.upperBound..<target.endIndex])
        if let second = source.locate(in: rest) {
            let length = rest.distance(from: rest.startIndex, to: second.lowerBound)
            let end = target.index(range.upperBound, offsetBy: length)
            return range.upperBound..<end
        }

        return range.upperBound..<target.endIndex
    }

    func replaceMatches(in target: String, to template: String) -> String {
        var result = ""
        source.iterate(over: target, configuredBy: .shallow) { fragment in
            switch fragment {
            case .match(let data):
                result.append(String(target[data]))

            case .text:
                result.append(template)

            case .subMatch:
                break
            }
            return true
        }
        return result
    }

    @discardableResult
    func iterate(over target: String,
                 configuredBy config: SearchConfig,
                 using block: (RangeFragment) -> Bool) -> Int {
        var matches = 0
        source.iterate(over: target, configuredBy: .shallow) { fragment in
            let result: Bool
            switch fragment {
            case .match(let data):
                result = block(.text(data))

            case .text(let data):
                result = block(.match(data))
                matches += 1

            case .subMatch:
                result = true
            }
            return result && config.allows(matchCount: matches+1)
        }
        return matches
    }
}

public extension InversePattern {
    var inverse: Pattern {
        return source
    }
}
