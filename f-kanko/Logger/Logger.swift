//
//  Logger.swift
//  f-kanko
//
//  Created by 野村弘樹 on 2022/07/14.
//

import Foundation

/// ログ出力クラス
class Logger {
    /// ログレベル
    enum LogLevel: String {
        case debug
        case info
        case warn
        case error
    }

    /// DateFormatterインスタンス
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter
    }()

    /// debugログ出力
    static func debug(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        Logger.printToConsole(logLevel: .debug, file: file, function: function, line: line, message: message)
    }

    /// infoログ出力
    static func info(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        Logger.printToConsole(logLevel: .info, file: file, function: function, line: line, message: message)
    }

    /// warnログ出力
    static func warn(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "") {
        Logger.printToConsole(logLevel: .warn, file: file, function: function, line: line, message: message)
    }

    /// errorログ出力
    static func error(file: String = #file, function: String = #function, line: Int = #line, _ message: String = "", _ error: Error? = nil) {
        Logger.printToConsole(logLevel: .error, file: file, function: function, line: line, message: message, error: error)
    }

    /// ログ出力
    private static func printToConsole(logLevel: LogLevel, file: String, function: String, line: Int, message: String, error: Error? = nil) {
        #if DEBUG
        // 現在日時
        let dateString = Logger.dateFormatter.string(from: Date())

        // クラス名
        let fileName = file.components(separatedBy: "/").last
        let className = fileName?.components(separatedBy: ".").first ?? ""

        // ログ出力
        print("\(dateString) [\(logLevel.rawValue.uppercased())] \(className).\(function) #\(line): \(message)")
        guard let error = error else { return }
        print("Error:\n  Detail: \(error)\n  Description: \(error.localizedDescription)")
        #endif
    }
}
