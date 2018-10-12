//
//  mapvector.swift
//  swiftsearchengine
//
//  Created by Sanjay Yepuri on 10/11/18.
//  Copyright © 2018 Sanjay Yepuri. All rights reserved.
//

import Foundation

class MapVector {
    var vector: [String: Double]
    
    var length: Double {
        get {
            var sum: Double = 0
            for (_, weight) in self.vector {
                sum += pow(weight, 2)
            }
            return sqrt(sum)
        }
    }
    
    init() { self.vector = [:] }
    init(vector: [String: Double]) {
        self.vector = vector
    }
    
    static func +(left: MapVector, right: MapVector) -> MapVector {
        return MapVector(vector: left.vector.merging(right.vector, uniquingKeysWith: {$0 + $1}))
    }
    
    static func -(left: MapVector, right: MapVector) -> MapVector {
        return MapVector(vector: left.vector.merging(right.vector, uniquingKeysWith: {$0 - $1}))
    }
    
    func increment(token: String, weight: Double) -> Void {
        if vector[token] != nil {
            vector[token]! += weight
        } else {
            vector[token] = weight
        }
    }
    
    func scale(factor: Double) -> Void {
        for (token, weight) in vector {
            vector[token] = factor * weight
        }
    }
    
    func dotProduct(other: MapVector) -> Double {
        
        var sum: Double = 0;
        for (token, weight) in self.vector {
            if let w = other.vector[token] {
                sum += w*weight
            }
        }
        return sum
    }
    
    func cosineSimilarity(other: MapVector) -> Double{
        return dotProduct(other: other)/(length * other.length)
    }
}
