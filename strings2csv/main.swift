//
//  main.swift
//  strings2csv
//
//  Created by David Gavilan on 24/01/2022.
//

import Foundation

func stringsFileToDictionary(_ lines: [String]) -> [String: String] {
    var dict: [String: String] = [:]
    for s in lines {
        let g = getGroupsFromRegex(pattern: #"^"([-\.\w]+)"\s*=\s*(".+");\s*$"#, in: s)
        if g.count == 0 {
            continue
        }
        dict[g[0][0]] = g[0][1]
    }
    return dict
}

func main() {
    do {
        let cli = try CLI()
        print("keys," + cli.languages.joined(separator: ","))
        var dictOfDicts: [String: [String: String]] = [:]
        for lang in cli.languages {
            let dict = stringsFileToDictionary(cli.langFiles[lang]!)
            dictOfDicts[lang] = dict
        }
        let mainLang = cli.languages[0]
        for key in dictOfDicts[mainLang]!.keys.sorted() {
            var s = [key]
            for lang in cli.languages {
                guard let translation = dictOfDicts[lang]![key] else {
                    throw CLI.Error.missingKey(name: key)
                }
                s.append(translation)
            }
            print(s.joined(separator: ","))
        }
    } catch {
        print(error.localizedDescription)
    }
}

main()
