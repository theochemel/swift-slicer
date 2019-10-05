import Foundation

let bunnySTLFilepath = "/Users/theo/Documents/swift-slicer/Models/High_Resolution_Stanford_Bunny/FLATFOOT_StanfordBunny_jmil_Super-HIGH_RES_Smoothed.stl"
let bunnyModel = Model(fromFile: bunnySTLFilepath, name: "Bunny")
let slicer = Slicer()
let cuttingPlanes = slicer.slice(model: bunnyModel, layerHeight: 0.2)

let svgExporter = SVGExporter()

for (index, cuttingPlane) in cuttingPlanes.enumerated() {
    let fileString = svgExporter.export(segments: cuttingPlane.segments)
    try? fileString.write(to: URL(fileURLWithPath: "/Users/theo/slices/slice\(index).svg"), atomically: false, encoding: .utf8)
}
