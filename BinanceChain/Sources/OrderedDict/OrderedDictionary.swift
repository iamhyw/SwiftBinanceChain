//
//  OrderedDictionary.swift
//  M13OrderedDictionary, https://github.com/Marxon13/M13DataStructures
//
// The MIT License (MIT)
//
// Copyright 2014 Brandon McQuilkin, modifications for Swift 1.2 Marko Wallin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

struct OrderedDictionary<KeyType: Hashable, ValueType>: Sequence, CustomStringConvertible {
    fileprivate var keyStorage: Array<KeyType> = []
    fileprivate var pairStorage: Dictionary<KeyType, ValueType> = [:]
    
    //MARK: Initalization
    
    /**Constructs an empty ordered dictionary.*/
    init() {
        
    }
    
    /**Constructs an ordered dictionary with the keys and values in a dictionary.*/
    init(dictionary: Dictionary<KeyType, ValueType>) {
        for aKey in dictionary.keys {
            keyStorage.append(aKey)
        }
        pairStorage = dictionary
    }
    
    /**Constructs an ordered dictionary with the keys and values from another ordered dictionary.*/
    init(orderedDictionary: OrderedDictionary<KeyType, ValueType>) {
        keyStorage = orderedDictionary.keyStorage
        pairStorage = orderedDictionary.pairStorage
    }
    
    //MARK: Subscripts
    
    /**Gets or sets existing entries in an ordered dictionary by key using square bracket subscripting. If a key exists this will overrite the object for said key, not changing the order of keys. If the key does not exist, it will be appended at the end of the ordered dictionary.*/
    subscript(key: KeyType) -> ValueType? {
        get {
            return pairStorage[key]
        }
        mutating set(newValue) {
            if pairStorage[key] != nil {
                pairStorage[key] = newValue
            } else {
                keyStorage.append(key)
                pairStorage[key] = newValue
            }
        }
    }
    
    /**Gets or sets existing entries in an ordered dictionary by index using square bracket subscripting. If the key exists, its entry will be deleted, before the new entry is inserted; also, the insertion compensates for the deleted key, so the entry will end up between the same to entries regardless if a key is deleted or not.*/
    subscript(index: Int) -> (KeyType, ValueType) {
        get {
            let key: KeyType = keyStorage[index]
            let value: ValueType = pairStorage[key]!
            return (key, value)
        }
        set(newValue) {
            let (key, value): (KeyType, ValueType) = newValue
            if pairStorage[key] != nil {
                var idx: Int = 0
                if let keyIndex = keyStorage.firstIndex(of: key) {
                    if index > keyIndex {
                        //Compensate for the deleted entry
                        idx = index - 1
                    } else {
                        idx = index
                    }
                    
                    //Remove the old entry
                    keyStorage.remove(at: keyIndex)
                    //Insert the new one
                    pairStorage[key] = value
                    keyStorage.insert(key, at: idx)
                }
            } else {
                //No previous value
                keyStorage.insert(key, at: index)
                pairStorage[key] = value
            }
        }
    }
    
    /**Gets or a subrange of existing keys in an ordered dictionary using square bracket subscripting with an integer range.*/
    subscript(keyRange keyRange: Range<Int>) -> ArraySlice<KeyType> {
        get {
            return keyStorage[keyRange]
        }
    }
    
    /**Gets or a subrange of existing values in an ordered dictionary using square bracket subscripting with an integer range.*/
    subscript(valueRange valueRange: Range<Int>) -> ArraySlice<ValueType> {
        get {
            return self.values[valueRange]
        }
    }
    
    //MARK: Adding
    
    /*Adds a new entry as the last element in an existing ordered dictionary.*/
    mutating func append(_ newElement: (KeyType, ValueType)) {
        let (key, value) = newElement
        pairStorage[key] = value
        keyStorage.append(key)
    }
    
    /*Inserts an entry into the collection at a given index. If the key exists, its entry will be deleted, before the new entry is inserted; also, the insertion compensates for the deleted key, so the entry will end up between the same to entries regardless if a key is deleted or not.*/
    mutating func insert(_ newElement: (KeyType, ValueType), atIndex: Int) {
        self[atIndex] = newElement
    }
    
    //MARK: Updating
    
    /**Inserts at the end or updates a value for a given key and returns the previous value for that key if one existed, or nil if a previous value did not exist.*/
    mutating func updateValue(_ value: ValueType, forKey: KeyType) -> ValueType? {
        let test: ValueType? = pairStorage.updateValue(value, forKey: forKey)
        if test != nil {
            //The key already exists, no need to add
        } else {
            keyStorage.append(forKey)
        }
        return test
    }
    
    //MARK: Removing
    
    /**Removes the key-value pair for the specified key and returns its value, or nil if a value for that key did not previously exist.*/
    mutating func removeEntryForKey(_ key: KeyType) -> ValueType? {
        if let index = keyStorage.firstIndex(of: key) {
            keyStorage.remove(at: index)
        }
        return pairStorage.removeValue(forKey: key)
    }
    
    /**Removes all the elements from the collection and clears the underlying storage buffer.*/
    mutating func removeAllEntries() {
        keyStorage.removeAll(keepingCapacity: false)
        pairStorage.removeAll(keepingCapacity: false)
    }
    
    /**Removes the entry at the given index and returns it.*/
    mutating func removeEntryAtIndex(_ index: Int) -> (KeyType, ValueType) {
        let key: KeyType = keyStorage[index]
        let value: ValueType = pairStorage.removeValue(forKey: key)!
        keyStorage.remove(at: index)
        return (key, value)
    }
    
    /**Removes the last entry from the collection and returns it.*/
    mutating func removeLastEntry() -> (KeyType, ValueType) {
        let key: KeyType = keyStorage[keyStorage.endIndex]
        let value: ValueType = pairStorage.removeValue(forKey: key)!
        keyStorage.removeLast()
        return (key, value)
    }
    
    //MARK: Properties
    
    /**An integer value that represents the number of elements in the ordered dictionary (read-only).*/
    var count: Int { get {
        return keyStorage.count
        }}
    
    /**A Boolean value that determines whether the ordered dictionary is empty (read-only).*/
    var isEmpty: Bool { get {
        return keyStorage.isEmpty
        }}
    
    //MARK: Enumeration
    
    /*Returns an ordered iterable collection of all of an ordered dictionary’s keys.*/
    var keys: Array<KeyType> {
        get {
            return keyStorage
        }
    }
    
    /*Returns an ordered iterable collection of all of an ordered dictionary’s values.*/
    var values: Array<ValueType> {
        get {
            var tempArray: Array<ValueType> = []
            for key: KeyType in keyStorage {
                tempArray.append(pairStorage[key]!)
            }
            return tempArray
        }
    }
    
    /*Returns an ordered iterable collection of all of an ordered dictionary’s entries.*/
    var entries: Array<(KeyType, ValueType)> {
        get {
            var tempArray: Array<(KeyType, ValueType)> = []
            for key: KeyType in keyStorage {
                let temp = (key, pairStorage[key]!)
                tempArray.append(temp)
            }
            return tempArray
        }
    }
    
    //MARK: Sorting
    
    /**Sorts the receiver in place using a given closure to determine the order of a provided pair of elements.*/
    mutating func sort(isOrderedBefore sortFunction: ((KeyType, ValueType), (KeyType, ValueType)) -> Bool) {
        var tempArray = Array(pairStorage)
        tempArray.sort(by: sortFunction)
        keyStorage = tempArray.map({
            let (key, _) = $0
            return key
        })
    }
    
    /**Sorts the receiver in place using a given closure to determine the order of a provided pair of elements by their keys.*/
    mutating func sortByKeys(isOrderedBefore sortFunction: (KeyType, KeyType) -> Bool) {
        keyStorage.sort(by: sortFunction)
    }
    
    /**Sorts the receiver in place using a given closure to determine the order of a provided pair of elements by their values.*/
    mutating func sortByValues(isOrderedBefore sortFunction: (ValueType, ValueType) -> Bool) {
        var tempArray = Array(pairStorage)
        tempArray.sort(by: {
            let (_, aValue) = $0
            let (_, bValue) = $1
            return sortFunction(aValue, bValue)
        })
        keyStorage = tempArray.map({
            let (key, _) = $0
            return key
        })
    }
    
    /**Returns an ordered dictionary containing elements from the receiver sorted using a given closure.*/
    func sorted(_ isOrderedBefore: ((KeyType, ValueType), (KeyType, ValueType)) -> Bool) -> OrderedDictionary<KeyType, ValueType> {
        var temp: OrderedDictionary = OrderedDictionary(orderedDictionary: self)
        temp.sort(isOrderedBefore: isOrderedBefore)
        return temp
    }
    
    /**Returns an ordered dictionary containing elements from the receiver sorted using a given closure by their keys.*/
    func sortedByKeys(_ isOrderedBefore: (KeyType, KeyType) -> Bool) -> OrderedDictionary<KeyType, ValueType> {
        var temp: OrderedDictionary = OrderedDictionary(orderedDictionary: self)
        temp.sortByKeys(isOrderedBefore: isOrderedBefore)
        return temp
    }
    
    /**Returns an ordered dictionary containing elements from the receiver sorted using a given closure by their values.*/
    func sortedByValues(_ isOrderedBefore: (ValueType, ValueType) -> Bool) -> OrderedDictionary<KeyType, ValueType> {
        var temp: OrderedDictionary = OrderedDictionary(orderedDictionary: self)
        temp.sortByValues(isOrderedBefore: isOrderedBefore)
        return temp
    }
    
    /**Returns an ordered dictionary containing the elements of the receiver in reverse order by index.*/
    func reverse() -> OrderedDictionary<KeyType, ValueType> {
        var temp = OrderedDictionary(orderedDictionary: self)
        temp.keyStorage = Array(temp.keyStorage.reversed())
        return temp
    }
    
    /**Returns an ordered dictionary containing the elements of the receiver for which a provided closure indicates a match.*/
    func filter(includeElement filterFunction: ((KeyType, ValueType)) -> Bool) -> OrderedDictionary<KeyType, ValueType> {
        let tempArray = self.entries.filter(filterFunction)
        var temp = OrderedDictionary()
        for entry in tempArray {
            temp.append(entry)
        }
        return temp
    }
    
    /**Returns an ordered dictionary of elements built from the results of applying a provided transforming closure for each element.*/
    func map<NewKeyType, NewValueType>(transform aTransform: (KeyType, ValueType) -> (NewKeyType, NewValueType)) -> OrderedDictionary<NewKeyType, NewValueType> {
        let tempArray = Array(pairStorage)
        let newArray = tempArray.map(aTransform)
        var temp: OrderedDictionary<NewKeyType, NewValueType> = OrderedDictionary<NewKeyType, NewValueType>()
        for entry in newArray {
            temp.append(entry)
        }
        return temp
    }
    
    /**Returns an array of elements built from the results of applying a provided transforming closure for each element.*/
    func mapToArray<T>(transform aTransform: (KeyType, ValueType) -> T) -> Array<T> {
        let tempArray = Array(pairStorage)
        return tempArray.map(aTransform)
    }
    
    /**Returns a single value representing the result of applying a provided reduction closure for each element.*/
    func reduce<NewKeyType, NewValueType>(initial value: (NewKeyType, NewValueType), combine combo: ((NewKeyType, NewValueType), (KeyType, ValueType)) -> (NewKeyType, NewValueType)) ->  (NewKeyType, NewValueType) {
        let tempArray = Array(pairStorage)
        return tempArray.reduce(value, combo)
    }
    
    //MARK: Printable
    var description: String {
        get {
            var temp: String = "OrderedDictionary {\n"
            let entries = self.entries
            let int = 0
            for entry in entries {
                let (key, value) = entry
                temp += "    [\(int)] {\(key): \(value)}\n"
            }
            temp += "}"
            return temp
        }
    }
    
    //MARK: Sequence
    func makeIterator() -> IndexingIterator<[(KeyType, ValueType)]> {
        return self.entries.makeIterator()
    }
    
}

//MARK: Operators

/**Determines the equality of two ordered dictionaries. Evaluates to true if the two ordered dictionaries contain exactly the same keys and values in the same order.*/
func == <KeyType, ValueType: Equatable>(lhs: OrderedDictionary<KeyType, ValueType>, rhs: OrderedDictionary<KeyType, ValueType>) -> Bool {
    return lhs.keyStorage == rhs.keyStorage && lhs.pairStorage == rhs.pairStorage
}

/**Determines the similarity of two ordered dictionaries. Evaluates to true if the two ordered dictionaries contain exactly the same keys and values but not necessarly in the same order.*/
func ~= <KeyType, ValueType : Equatable>(lhs: OrderedDictionary<KeyType, ValueType>, rhs: OrderedDictionary<KeyType, ValueType>) -> Bool {
    return lhs.pairStorage == rhs.pairStorage
}

/**Determines the inequality of two ordered dictionaries. Evaluates to true if the two ordered dictionaries do not contain exactly the same keys and values in the same order*/
func != <KeyType, ValueType : Equatable>(lhs: OrderedDictionary<KeyType, ValueType>, rhs: OrderedDictionary<KeyType, ValueType>) -> Bool {
    return lhs.keyStorage != rhs.keyStorage || lhs.pairStorage != rhs.pairStorage
}
