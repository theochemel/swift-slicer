import Foundation

let bunnySTLFilepath = "/Users/theo/Documents/swift-slicer/Models/High_Resolution_Stanford_Bunny/FLATFOOT_StanfordBunny_jmil_Super-HIGH_RES_Smoothed.stl"
let bunnyModel = Model(fromFile: bunnySTLFilepath, name: "Bunny")
let slicer = Slicer()
slicer.slice(model: bunnyModel, layerHeight: 1.0)
