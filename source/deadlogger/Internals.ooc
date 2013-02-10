use deadlogger

version (android) {
    include android/log

    ANDROID_LOG_VERBOSE: extern Int
    ANDROID_LOG_DEBUG: extern Int
    ANDROID_LOG_INFO: extern Int
    ANDROID_LOG_WARN: extern Int
    ANDROID_LOG_ERROR: extern Int

    __android_log_print: extern func (level: Int, loggerName: CString, ...) 

    internalLog("Hi from deadlogger!")
}

internalLog: func (fmt: String, args: ...) {
    result := fmt format(args)

    version (android) {
        // Oh yeah, android, we have to do something special for you. Just for you.
        __android_log_print(ANDROID_LOG_INFO, "deadlogger", result toCString())
    }
}
