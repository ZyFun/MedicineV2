//
//  CustomLogger.swift
//  MedicinesV2
//
//  Created by Дмитрий Данилин on 07.09.2022.
//

import Foundation
import os.log

enum CustomLogger {
    enum LogLevel {
        case info
        case warning
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .info:
                return "INFO ℹ️"
            case .warning:
                return "WARNING ⚠️"
            case .error:
                return "ERROR ❌"
            }
        }
    }
    
    struct LogContext {
        let file: String
        let function: String
        let line: Int
        var description: String {
            "\((file as NSString).lastPathComponent): \(line) \(function)"
        }
    }
    
    static func info(
        _ message: String,
        showInConsole: Bool? = true,
        shouldLogContext: Bool? = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logContext = LogContext(
            file: file,
            function: function,
            line: line
        )
        
        CustomLogger.handleLog(
            level: .info,
            message: message,
            showInConsole: showInConsole ?? false,
            shouldLogContext: shouldLogContext ?? false,
            context: logContext
        )
    }
    
    static func warning(
        _ message: String,
        showInConsole: Bool? = true,
        shouldLogContext: Bool? = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logContext = LogContext(
            file: file,
            function: function,
            line: line
        )
        
        CustomLogger.handleLog(
            level: .warning,
            message: message,
            showInConsole: showInConsole ?? false,
            shouldLogContext: shouldLogContext ?? false,
            context: logContext
        )
    }
    
    static func error(
        _ message: String,
        showInConsole: Bool? = true,
        shouldLogContext: Bool? = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logContext = LogContext(
            file: file,
            function: function,
            line: line
        )
        
        CustomLogger.handleLog(
            level: .error,
            message: message,
            showInConsole: showInConsole ?? false,
            shouldLogContext: shouldLogContext ?? false,
            context: logContext
        )
    }
    
    fileprivate static func handleLog(
        level: LogLevel,
        message: String,
        showInConsole: Bool,
        shouldLogContext: Bool,
        context: LogContext
    ) {
        let logComponents = ["[\(level.prefix)]", message]
        
        var fullString = logComponents.joined(separator: " ")
        
        if showInConsole {
            if shouldLogContext {
                fullString += " -> \(context.description)"
            }
            
//            printDebug(fullString)
            
            guard let module = URL(fileURLWithPath: context.file).deletingPathExtension().pathComponents.last else { return }
            let formattedMessage = [message, context.description, "=========="].joined(separator: "\n\n")
            let osLog = OSLog(subsystem: module, category: level.prefix)
            
            switch level {
            case .info:
                os_log(.info,
                       log: osLog,
                       "%{private}@", formattedMessage)
            case .warning:
                os_log(.error,
                       log: osLog,
                       "%{private}@", formattedMessage)
            case .error:
                os_log(.fault,
                       log: osLog,
                       "%{private}@", formattedMessage)
            }
        }
    }
}
