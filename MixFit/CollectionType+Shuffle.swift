//
//  CollectionType+Shuffle.swift
//  MixFit
//
//  Created by Kellen Pierson on 7/11/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import Foundation

extension Collection {
    // Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int, IndexDistance == Int {
    // Shuffle the elements of 'self' in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }

        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
