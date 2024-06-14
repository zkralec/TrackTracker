//
//  DotEnv.swift
//  Track Tracker
//
//  Created by Zachary Kralec on 6/14/24.
//

import Foundation

enum DotEnvError: Error {
    case fileNotFound
    case unableToConvertToString
}

struct DotEnv {
    static func get(_ key: String) throws -> String {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            throw DotEnvError.fileNotFound
        }

        guard let fileContents = try? String(contentsOfFile: path, encoding: .utf8) else {
            throw DotEnvError.fileNotFound
        }

        let lines = fileContents.components(separatedBy: .newlines)

        for line in lines {
            let pair = line.components(separatedBy: "=")
            guard pair.count == 2 else { continue }
            let trimmedKey = pair[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedValue = pair[1].trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedKey == key {
                return trimmedValue
            }
        }

        throw DotEnvError.fileNotFound
    }
}
