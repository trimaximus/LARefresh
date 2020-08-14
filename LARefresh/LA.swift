//
//  LA.swift
//  LARefreshDemo
//
//  Created by trimaximus on 2020/8/14.
//  Copyright © 2020 LiteAtom. All rights reserved.
//

import UIKit

public protocol LAExtensionProvider: class {
    associatedtype CompatibleType
    var la: CompatibleType { get set }
}

extension LAExtensionProvider {
    public var la: LA<Self> {
        get {
            return LA(self)
        }
        set {
            
        }
    }
}

public struct LA<Base> {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension UIView: LAExtensionProvider {}
