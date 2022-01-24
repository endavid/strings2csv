//
//  Util.swift
//  strings2csv
//
//  Created by David Gavilan on 24/01/2022.
//

import Foundation

func getGroupsFromRegex(pattern: String, in line: String) -> [[String]] {
    let range = NSRange(location: 0, length: line.utf16.count)
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    guard let matches = regex?.matches(in: line, options: [], range: range) else {
        return []
    }
    var out: [[String]] = []
    for m in matches {
        var groups: [String] = []
        if m.numberOfRanges < 2 {
            continue
        }
        for i in 1..<m.numberOfRanges {
            if let r = Range(m.range(at: i), in: line) {
                groups.append(String(line[r]))
            }
        }
        out.append(groups)
    }
    return out
}
