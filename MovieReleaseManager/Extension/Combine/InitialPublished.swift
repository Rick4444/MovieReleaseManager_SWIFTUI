//
//  InitialPublished.swift
//  MovieReleaseManager
//
//  Created by Rameshwar Gupta on 17/07/22.
//

import Foundation
import Combine

@propertyWrapper // @propertyDelegate
struct InitialPublished<Value>: Publisher {
    typealias Output = Value
    typealias Failure = Never
    
    private let subject: CurrentValueSubject<Output, Failure>
    
    var wrappedValue: Value {
        get { subject.value }
        set { subject.send(newValue) }
    }
    
    init(wrappedValue initialValue: Value) {
        subject = CurrentValueSubject(initialValue)
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Value == S.Input {
        subject.receive(subscriber: subscriber)
    }
}
