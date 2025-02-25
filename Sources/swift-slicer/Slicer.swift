import Foundation
import simd

class Slicer {
    
    func slice(model: Model, layerHeight: Float) -> [CuttingPlane] {
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
            for cuttingPlaneIndex in 0 ..< cuttingPlanes.count {
                if let lineSegment = getIntersection(cuttingPlanes[cuttingPlaneIndex], triangle) {
                    cuttingPlanes[cuttingPlaneIndex].segments.append(lineSegment)
                }
            }
        }
        
        return cuttingPlanes
    }
    
    func getIntersection(_ plane: CuttingPlane, _ triangle: Triangle) -> LineSegment? {
        let vertex1Distance = getDistance(fromVertex: triangle.vertex1, toCuttingPlane: plane)
        let vertex2Distance = getDistance(fromVertex: triangle.vertex2, toCuttingPlane: plane)
        let vertex3Distance = getDistance(fromVertex: triangle.vertex3, toCuttingPlane: plane)
        
        if vertex1Distance > 0 && vertex2Distance > 0 && vertex3Distance > 0 {
            
        } else if vertex1Distance < 0 && vertex2Distance < 0 && vertex3Distance < 0 {
            
        } else {
            // Actually calculate intersection line segments
            
            var intersectPoints: [simd_float3] = []
            
            if vertex2Distance * vertex1Distance < 0 {
                let s10 = vertex2Distance / (vertex2Distance - vertex1Distance)
                
                intersectPoints.append(triangle.vertex1 + ((triangle.vertex2 - triangle.vertex1) * simd_float3(repeating: s10)))
            }
            
            if vertex3Distance * vertex2Distance < 0 {
                let s21 = vertex3Distance / (vertex3Distance - vertex2Distance)
                intersectPoints.append(triangle.vertex2 + ((triangle.vertex3 - triangle.vertex2) * simd_float3(repeating: s21)))
            }
            
            if vertex1Distance * vertex3Distance < 0 {
                let s02 = vertex1Distance / (vertex1Distance - vertex3Distance)
                intersectPoints.append(triangle.vertex3 + ((triangle.vertex1 - triangle.vertex3) * simd_float3(repeating: s02)))
            }
            
            if vertex1Distance == 0 {
                intersectPoints.append(triangle.vertex1)
            }

            if vertex2Distance == 0 {
                intersectPoints.append(triangle.vertex2)
            }

            if vertex3Distance == 0 {
                intersectPoints.append(triangle.vertex3)
            }
            
            guard intersectPoints.count == 2 else { return nil }
            
            let intersection = LineSegment(start: intersectPoints[0], end: intersectPoints[1])
            return intersection
            
        }
        
        return nil
        
    }
    
    func getDistance(fromVertex vertex: simd_float3, toCuttingPlane plane: CuttingPlane) -> Float {
        return simd_dot(vertex, simd_float3(x: 0.0, y: 0.0, z: 1.0)) - plane.height
    }
    
    func getLinearInterpolation(_ start: simd_float3, _ end: simd_float3, _ distance: Float) -> simd_float3 {
        let distanceVector = simd_float3(repeating: distance)
        return simd_mix(start, end, distanceVector)
        
    }
    
}
