//**************************************************************
//
//  FragmentType
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Fragment types for search configuration filtering
 */
public struct FragmentType: OptionSet {
    /** section for matches */
    public static let match                     = FragmentType(type: 0)
    /** section for matches within matches */
    public static let subMatch                  = FragmentType(type: 1)
    /** section for text surrounding matches */
    public static let text                      = FragmentType(type: 2)

    /** all fragment type */
    public static let all: FragmentType         = [.match, .subMatch, .text]
    /** matches and sub-matches only */
    public static let allMatch: FragmentType    = [.match, .subMatch]

    /** OptionSet property */
    public let rawValue: Int

    /** OptionSet initializer */
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
