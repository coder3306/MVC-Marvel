//
//  CommonConfig.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/11.
//

import Foundation

public enum State {
    case loading
    case ready
    case error
}

public struct ModelCollection<Element>: Collection {
    private var _elements: [Element]?
    
    public var elements: [Element]? {
        get {
            return _elements
        } set {
            _elements = newValue
        }
    }
    
    public var startIndex: Int {
        return elements?.startIndex ?? 0
    }
    
    public var endIndex: Int {
        return elements?.endIndex ?? 0
    }
    
    public func index(after i: Int) -> Int {
        return elements?.index(after: i) ?? 0
    }
    
    public subscript(position: Int) -> Element? {
        return elements?[position]
    }
    
    public var isEmpty: Bool? {
        return elements?.isEmpty
    }
    
    public var count: Int? {
        return elements?.count
    }
    
    public func element(at index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return elements?[index]
    }
}
