//
//  File 2.swift
//  
//
//  Created by Theo Chemel on 10/4/19.
//

import Foundation

class SVGExporter {
    
    func export(segments: [LineSegment]) -> String {
        
        let viewBoxString = "-100 -100 200 200"
        var pathString = ""
        
        for segment in segments {
            pathString.append(" M \(segment.start.x) \(segment.start.y) L \(segment.end.x) \(segment.end.y)")
        }
        pathString.append("Z")
        
        let fileString = "<svg viewBox=\"\(viewBoxString)\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"\(pathString)\" fill=\"transparent\" stroke=\"black\"/></svg>"
        
        print(fileString)
        
        return fileString
    }
}
