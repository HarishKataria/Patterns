//**************************************************************
//
//  Fragment
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Generic fragment types
 */
public enum Fragment<DataType> {
    /** Matched region */
    case match(DataType)

    /** Unmatched region */
    case text(DataType)

    /** Match within a match region */
    case subMatch(DataType, id: SubMatchIdentifier)
}

public extension Fragment {
    /** value of the underlining fragment content */
    var content: DataType {
        switch self {
        case .match(let data):
            return data

        case .text(let data):
            return data

        case .subMatch(let data, _):
            return data
        }
    }

    /** transform between fragment data into another type */
    func map<X>(using block: (DataType) -> X) -> Fragment<X> {
        switch self {
        case .match(let data):
            return .match(block(data))

        case .text(let data):
            return .text(block(data))

        case .subMatch(let data, let id):
            return .subMatch(block(data), id: id)
        }
    }
}

public extension Fragment where DataType: CustomStringConvertible {
    /** content as string */
    var dataString: String {
        return content.description
    }
}
