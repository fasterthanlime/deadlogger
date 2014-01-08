import structs/[ArrayList,HashMap]
import text/StringTokenizer

import deadlogger/[Level, Handler, Internals]

NoSuchLoggerError: class extends Exception {
    init: func ~withMsg (.message) {
        super(message)
    }
    init: func ~withOrigin (origin: Class, .message) {
        super(origin, message)
    }
}

Logger: class {
    path: String
    subloggers: HashMap<String, Logger>
    handlers: ArrayList<Handler>
    parent: Logger

    init: func ~withParent (=path, =parent) {
        internalLog("Creating Logger with path %s, parent %p", path, parent)
        subloggers = HashMap<String, Logger> new()
        handlers = ArrayList<Handler> new()
    }

    init: func ~withoutParent (.path) {
        init(path, null)
    }

    getSubLogger: func (path: String, create: Bool) -> Logger {
        if(path contains?('.')) {
            idx := path indexOf('.')
            first := path substring(0, idx)
            rest := path substring(idx + 1, path length())
            return getSubLogger(first) getSubLogger(rest)
        } else {
            internalLog("Logger_getSubLogger(%s), subloggers address/size = %p / %d", path,
                subloggers, subloggers size)

            if(!subloggers contains?(path)) {
                if(!create) {
                    NoSuchLoggerError new(This, "No such logger: '%s'" format(path)) throw()
                } else {
                    logger := Logger new(path, this)
                    subloggers put(path, logger)
                }
            }
            return subloggers get(path)
        }
    }

    attachHandler: func (handler: Handler) {
        handlers add(handler)
    }

    detachHandler: func (handler: Handler) {
        handlers remove(handler)
    }

    getSubLogger: func ~alwaysCreate (path: String) -> Logger {
        getSubLogger(path, true)
    }

    log: func (level: Int, emitter: Logger, msg: String) {
        accepted := false
        for(handler: Handler in handlers) {
            if(handler handle(this, level, emitter, msg)) {
                accepted = true
            }
        }
        if(!accepted) {
            if(parent) {
                parent log(level, emitter, msg)
            } else {
                /* TODO: lost! */
            }
        }
    }

    log: func ~emit (level: Int, msg: String) {
        log(level, this, msg)
    }

    log: func ~var (level: Int, msg: String, args: ...) {
        log(level, this, msg format(args))
    }

    debug: func (msg: String) {
        log(Level debug, msg)
    }

    debug: func ~var (msg: String, args: ...) {
        log(Level debug, msg format(args))
    }

    info: func (msg: String) {
        log(Level info, msg)
    }

    info: func ~var (msg: String, args: ...) {
        log(Level info, msg format(args))
    }

    warn: func (msg: String) {
        log(Level warn, msg)
    }

    warn: func ~var (msg: String, args: ...) {
        log(Level warn, msg format(args))
    }

    error: func (msg: String) {
        log(Level error, msg)
    }

    error: func ~var (msg: String, args: ...) {
        log(Level error, msg format(args))
    }

    critical: func (msg: String) {
        log(Level critical, msg)
    }

    critical: func ~var (msg: String, args: ...) {
        log(Level critical, msg format(args))
    }

}
