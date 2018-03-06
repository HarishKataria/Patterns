//**************************************************************
//
//  ValueWrapper
//
//  Created by Harish Kataria
//  Copyright © 2018 Harish Kataria. All rights reserved.
//
//**************************************************************

import Foundation

/**
 * Pièce de résistance of this framework -- a wrapper to enable
 * the use of reference types with value-like semantics
 */
public struct ValueWrapper<ReferenceType: NSCopying & AnyObject> {
    /**
     * saved template for future copy
     */
    private let template: ReferenceType

    /**
     * initializer for storing a copy of the reference object
     * as a template for future copies
     *
     * - parameters:
     *   - template: object to copy
     */
    public init?(template: ReferenceType) {
        guard let instance = ValueWrapper.copy(template) else {
            return nil
        }
        self.template = instance
    }

    /**
     * independant value aka copy of the original reference
     */
    public var value: ReferenceType? {
        return ValueWrapper.copy(template)
    }

    /**
     * gets a copy of the given reference
     */
    private static func copy(_ template: ReferenceType) -> ReferenceType? {
        guard let instance = template.copy() as? ReferenceType else {
            return nil
        }
        return instance
    }
}

extension ValueWrapper: Equatable {
    /**
     * equality driven by the underline object's extactly reference match
     */
    public static func == (lhs: ValueWrapper<ReferenceType>, rhs: ValueWrapper<ReferenceType>) -> Bool {
        return lhs.template === rhs.template
    }
}

extension ValueWrapper where ReferenceType: Equatable {
    /**
     * equality driven by the underline object's equality operator
     */
    public static func == (lhs: ValueWrapper<ReferenceType>, rhs: ValueWrapper<ReferenceType>) -> Bool {
        return lhs.template == rhs.template
    }
}
