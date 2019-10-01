import Foundation
import simd

class Model {
  
  var name: String
  var filepath: String
  
  var triangleCount: Int
  var triangles: [Triangle]
  
  init(fromFile filepath: String, name: String) {
      
    self.name = name
    self.filepath = filepath

    let fileManager = FileManager.default
    guard let fileData = fileManager.contents(atPath: filepath) else { fatalError("Unable to load model file from disk.") }
    
    self.triangleCount = Int(fileData[80...83].withUnsafeBytes { $0.load(as: UInt32.self) })
    
    self.triangles = []
    
    for triangleByteOffset in stride(from: 84, to: fileData.count, by: 50) {
        
        var floats: [Float32] = []
        
        fileData.subdata(in: triangleByteOffset ..< triangleByteOffset + 48).withUnsafeBytes { rawBufferPointer in
            
            for floatByteOffset in stride(from: 0, through: 44, by: 4) {
                
                let floatValue = rawBufferPointer.load(fromByteOffset: floatByteOffset, as: Float32.self)
                floats.append(floatValue)
                
            }
        }
        
        guard floats.count == 12 else { fatalError("Actual float count does not match expected") }
        
        let triangle = Triangle(floats)
        self.triangles.append(triangle)
        
    }
    
    if self.triangles.count != self.triangleCount {
        fatalError("Actual model triangle count does not match expected")
    }
    
  }
}
