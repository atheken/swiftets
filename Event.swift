//
//  EventHandler.swift
//  gamevault
//
//  Created by Andrew Theken on 2/21/15.
//  Copyright (c) 2015 Andrew Theken. All rights reserved.
//

class Event<T> {
    typealias EventHandler = (T -> ())
    typealias Handle = EventHandle<T>

    var handlers = Set<Handle>()

    func subscribe(handler: Handle) {
        handlers.insert(handler)
    }

    // Broadcast an event to all listeners.
    func invoke(sender: T) {

        var removal = Set<Handle>()

        for s in handlers {
            if s.Object != nil {
                s.Handler(sender)
            }
            else{
                removal.insert(s)
            }
        }

        handlers.subtractInPlace(removal)
    }
}

// Shorthand for subscribing event handlers.
func +=<T>(event: Event<T>, handler: EventHandle<T>) {
    event.subscribe(handler)
}

// Required for Equatable protocol conformance.
func ==<T>(lhs: EventHandle<T>, rhs: EventHandle<T>) -> Bool{
    return false
}

// Wrap a thunk so that we can determine if the "owning" object
// has been deallocated.
class EventHandle<T> : Hashable, Equatable {

    weak var Object:AnyObject? = nil
    var Handler:(T->Void)

    var hashValue = 0

    init(object:AnyObject, handler:(T->Void)){
        Object = object
        Handler = handler
        self.hashValue = object.hashValue
    }
}

// Allow observing object to be deallocated,
// and the handle to be deregistered, later.
func handle<T>(object:AnyObject, handler:(T->Void)) -> EventHandle<T> {
    return EventHandle(object:object, handler: handler)
}
