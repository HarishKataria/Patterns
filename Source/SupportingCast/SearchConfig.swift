//**************************************************************
//
//  SearchConfig
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Search configuration value type
 */
public struct SearchConfig {
    /** maximum number of matches allowed */
    public let maxMatches: MatchCount?
    /** types of fragments allowed */
    public let fragment: FragmentType
    /** generic payload for custom patterns to use */
    public let userData: Any?

    /** init with fragment, maxMatches and userData */
    public init(fragment: FragmentType = .all,
                maxMatches: MatchCount? = nil,
                userData: Any? = nil) {
        self.maxMatches = maxMatches
        self.fragment = fragment
        self.userData = userData
    }
}

/**
 * common configurations
 */
public extension SearchConfig {
    /** allow all search results */
    static let all          = SearchConfig()
    /** allow matched region results only */
    static let matches      = SearchConfig(fragment: .match)
    /** allow match and sub-match results only */
    static let deepMatches  = SearchConfig(fragment: .allMatch)
    /** allow only one match result */
    static let firstMatch   = SearchConfig(fragment: .allMatch, maxMatches: 1)
    /** allow only unmatched region results */
    static let text         = SearchConfig(fragment: .text)
    /** allow only matched and unmatched (but not sub-match) results */
    static let shallow      = SearchConfig(fragment: [.match, .text])
}

public extension SearchConfig {
    /**
     * checks if the new match count is allowed by this configuration
     */
    func allows(matchCount count: MatchCount) -> Bool {
        guard let maxMatches = maxMatches else {
            return true
        }
        return count <= maxMatches
    }

    /**
     * get a new configuration with the new match count
     */
    func set(maxMatches value: MatchCount) -> SearchConfig {
        if maxMatches == value {
            return self
        }
        return SearchConfig(fragment: fragment, maxMatches: maxMatches, userData: userData)
    }

    /**
     * get a new configuration with the new fragment types allowed
     */
    func set(fragment value: FragmentType) -> SearchConfig {
        if fragment == value {
            return self
        }
        return SearchConfig(fragment: fragment, maxMatches: maxMatches, userData: userData)
    }

    /**
     * get a new configuration without the given fragment type
     */
    func remove(fragment removed: FragmentType) -> SearchConfig {
        var value = fragment
        if value.remove(removed) == nil {
            return self
        }
        return SearchConfig(fragment: value, maxMatches: maxMatches, userData: userData)
    }
}
