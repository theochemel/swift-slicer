import simd

struct Triangle { 
    var normal: simd_float3
    var vertex1: simd_float3
    var vertex2: simd_float3
    var vertex3: simd_float3
    
    init(_ floats: [Float32]) {
        normal = simd_float3(x: floats[0], y: floats[1], z: floats[2])
        vertex1 = simd_float3(x: floats[3], y: floats[4], z: floats[5])
        vertex2 = simd_float3(x: floats[6], y: floats[7], z: floats[8])
        vertex3 = simd_float3(x: floats[9], y: floats[10], z: floats[11])
    }
    
}
