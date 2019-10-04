import Foundation
import simd

class Slicer {
    
    func slice(model: Model, layerHeight: Float) {
        print("Slicing model \(model.name), \(model.triangleCount) triangular faces.")
        
        guard model.triangles.count > 0 else { fatalError("Error slicing model: cannot slice model with no triangular faces") }
        
        var zMin = model.triangles.first!.vertex1.z
        var zMax = model.triangles.first!.vertex1.z
        
        for triangle in model.triangles {
            if triangle.vertex1.z < zMin { zMin = triangle.vertex1.z }
            if triangle.vertex2.z < zMin { zMin = triangle.vertex2.z }
            if triangle.vertex3.z < zMin { zMin = triangle.vertex3.z }
            if triangle.vertex1.z > zMax { zMax = triangle.vertex1.z }
            if triangle.vertex2.z > zMax { zMax = triangle.vertex2.z }
            if triangle.vertex3.z > zMax { zMax = triangle.vertex3.z }
        }
        
        let modelHeight = zMax - zMin
        
        guard modelHeight > 0.0 else { fatalError("Error slicing model: cannot slice model with negative model height") }
        
        var cuttingPlanes: [CuttingPlane] = []
        
        for cuttingPlaneHeight in stride(from: zMin + layerHeight, to: zMax, by: layerHeight) {
            cuttingPlanes.append(CuttingPlane(height: cuttingPlaneHeight, segments: []))
        }
        
        for triangle in model.triangles {
            for var cuttingPlane in cuttingPlanes {
                if let lineSegment = getIntersection(cuttingPlane, triangle) {
                    cuttingPlane.segments.append(lineSegment)
                }
            }
        }
    }
    
    func getIntersection(_ plane: CuttingPlane, _ triangle: Triangle) -> LineSegment? {
        let vertex1Distance = getDistance(fromVertex: triangle.vertex1, toCuttingPlane: plane)
        let vertex2Distance = getDistance(fromVertex: triangle.vertex2, toCuttingPlane: plane)
        let vertex3Distance = getDistance(fromVertex: triangle.vertex3, toCuttingPlane: plane)
        
        if vertex1Distance > 0 && vertex2Distance > 0 && vertex3Distance > 0 {
            
        } else if vertex1Distance < 0 && vertex2Distance < 0 && vertex3Distance < 0 {
            
        } else {
            // Actually calculate intersection line segments
        }
        
        return nil
    }
    
    func getDistance(fromVertex vertex: simd_float3, toCuttingPlane plane: CuttingPlane) -> Float {
        return simd_dot(vertex, simd_float3(x: 0.0, y: 0.0, z: 1.0)) - plane.height
    }
    
}
