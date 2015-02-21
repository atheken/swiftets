class Event<T> {
    typealias EventHandler = (T -> ())

    var handlers: [EventHandler] = []

    func subscribe(handler: EventHandler) {
        // I think this should be a weak refernece,
        // but I need to research how to do this in swift.
        handlers.append(handler)
    }

    func invoke(sender: T) {
        handlers.map({$0(sender)})
    }
}

func +=<T>(event: Event<T>, handler: (T -> Void)) {
    event.subscribe(handler)
}
