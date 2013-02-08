
version (android) {
    import deadlogger/[Formatter, Filter, Logger, Level, Handler, Internals]

    AndroidHandler: class extends ExtendedHandler {
        init: func {
        }

        send: func (logger: Logger, level: Int, emitter: Logger, msg, formatted: String) {
            __android_log_print(mapLevel(level), emitter path, msg toCString())
        }

        /**
         * Map deadlogger levels to Android levels
         */
        mapLevel: static func (level: Int) -> Int {
            match level {
                case Level debug =>
                    ANDROID_LOG_DEBUG
                case Level info =>
                    ANDROID_LOG_INFO
                case Level warn =>
                    ANDROID_LOG_WARN
                case Level error =>
                    ANDROID_LOG_ERROR
                case Level critical =>
                    ANDROID_LOG_ERROR
            }
        }
    }
}
