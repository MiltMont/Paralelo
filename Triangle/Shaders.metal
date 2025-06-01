//
//  Shaders.metal
//  Triangle
//
//  Created by Milton Montiel on 29/05/25.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_main(const VertexIn in [[stage_in]]) {
    VertexOut out {
        .position = in.position,
        .color = in.color,
    };
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]]) {
    return float4(1,1,1,1);
}
