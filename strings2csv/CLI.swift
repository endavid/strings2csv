//
//  CLI.swift
//  strings2csv
//
//  Created by David Gavilan on 24/01/2022.
//

import Foundation

class CLI {
    enum Error: LocalizedError {
        case noInputFile
        case fileDoesNotExist(name: String)
        case noLanguageFile(name: String)
        case missingKey(name: String)
        
        var errorDescription: String? {
            switch self {
            case .noInputFile:
                return "No input file"
            case .fileDoesNotExist(let f):
                return "\(f) does not exist"
            case .noLanguageFile(let f):
                return "\(f) not a language file"
            case .missingKey(let f):
                return "Missing key: \(f)"
            }
        }
    }
    
    let executable: String
    let langFiles: [String: [String]]
    let languages: [String]
    
    init() throws {
        executable = CommandLine.arguments[0]
        if CommandLine.arguments.count == 1 {
            throw Error.noInputFile
        }
        let mainFile = CommandLine.arguments[1]
        let g = getGroupsFromRegex(pattern: #"^(.+/?)(\w\w)(\.lproj/.+)$"#, in: mainFile)
        if g.count == 0 {
            throw Error.noLanguageFile(name: mainFile)
        }
        let pathPrefix = g[0][0]
        let pathSuffix = g[0][2]
        var langs = [g[0][1]]
        var files: [String: String] = [langs[0]: mainFile]
        for i in 2..<CommandLine.arguments.count {
            let lang = CommandLine.arguments[i]
            langs.append(lang)
            files[lang] = pathPrefix + lang + pathSuffix
        }
        let fileManager = FileManager.default
        for (_,f) in files {
            if !fileManager.fileExists(atPath: f) {
                throw Error.fileDoesNotExist(name: f)
            }
        }
        var dict: [String: [String]] = [:]
        for lang in langs {
            let f = files[lang]!
            let contents = try String(contentsOfFile: f)
            let lines = contents.split(separator:"\n").map { String($0) }
            dict[lang] = lines
        }
        languages = langs
        langFiles = dict
    }
}
