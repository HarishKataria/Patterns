//**************************************************************
//
//  Pattern
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

public extension Pattern {
    /**
     * Join the given pattern in an OR boolean operation
     */
    func or(_ rhs: Pattern) -> Pattern {
        return [self, rhs].or
    }

    /**
     * Join the given pattern in an AND boolean operation
     */
    func and(_ rhs: Pattern) -> Pattern {
        return [self, rhs].and
    }

    /**
     * create a new pattern that has a inverse matching stratergy
     */
    var inverse: Pattern {
        return InversePattern(source: self)
    }
}
