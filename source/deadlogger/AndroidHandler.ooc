
version (android) {
    import deadlogger/[Formatter, Filter, Logger, Level, Handler, Internals]

    AndroidHandler: class extends ExtendedHandler {
        init: func {
        }

        send: func (logger: Logger, level: Int, emitter: Logger, msg, formatted: String) {
            __android_log_print(level, emitter path, msg toCString())
        }
    }
}
