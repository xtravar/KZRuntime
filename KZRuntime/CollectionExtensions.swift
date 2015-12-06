//
//  CollectionExtensions.swift
//  KZRuntime
//
//  Created by Mike Kasianowicz on 11/8/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

extension CollectionType {
    typealias V = Self.Generator.Element
    func toDictionary<K: Hashable>(keyFunc: (element: V) -> K) -> [K: V]{
        var retval = [K:V]()
        self.forEach{ retval[keyFunc(element: $0)] = $0 }
        return retval
    }
}
