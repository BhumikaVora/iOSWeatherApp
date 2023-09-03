//
//  Async.swift
//  Created by Bhumika on 03/09/23.
//

import Foundation

// MARK: Async

public enum Async {
    
    public static func main(
        after seconds: Double? = nil,
        _ work: @escaping @convention(block) () -> Void)
    {
        custom(
            queue: DispatchQueue.main,
            after: seconds,
            work)
    }
    
    public static func custom(
        queue: DispatchQueue,
        after seconds: Double? = nil,
        _ work: @escaping @convention(block) () -> Void)
    {
        if let seconds {
            let time = DispatchTime.now() + seconds
            queue.asyncAfter(deadline: time, execute: work)
        }
        else {
            queue.async(execute: work)
        }
    }
}
