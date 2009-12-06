import deadlogger/[Formatter, Filter, Logger, Level]

Handler: abstract class {
    handle: abstract func (logger: Logger, level: Int, emitter: Logger, msg: String) -> Bool
}

ExtendedHandler: abstract class extends Handler {
    formatter: Formatter
    filter: Filter
    level: Int

    init: func ~withAll (=formatter, =filter, =level) {}
    
    init: func ~withFormatterAndLevel (.formatter, .level) {
        this(formatter, null, level)
    }
    
    init: func ~withFormatter (.formatter) { 
        this(formatter, null, 0)
    }
    
    init: func ~withNothing {
        this(null, null, 0)
    }
    
    setFormatter: func (=formatter) {}
    getFormatter: func -> Formatter { formatter }
    setFilter: func (=filter) {}
    getFilter: func -> Filter { filter }
    send: abstract func (logger: Logger, level: Int, emitter: Logger, msg, formatted: String)

    handle: func (logger: Logger, level: Int, emitter: Logger, msg: String) -> Bool {
        if(level < this level) {
            return false
        }
        if(filter && !filter isAccepted(this, logger, level, emitter, msg)) {
            return false
        }
        formatted := null
        if(formatter) {
            formatted = formatter format(this, logger, level, emitter, msg)
        } else {
            formatted = msg
        }
        send(logger, level, emitter, msg, formatted)
        return true
    }
}

PrintHandler: class extends ExtendedHandler {
    send: func (logger: Logger, level: Int, emitter: Logger, msg, formatted: String) {
        formatted println()
    }
}
