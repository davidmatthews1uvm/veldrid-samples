#version 450

struct ParticleInfo
{
    vec2 Position;
    vec2 Velocity;
    vec4 Color;
};

layout(std140, set = 0, binding = 0) readonly buffer ParticlesBuffer
{
    ParticleInfo Particles[];
};

layout(set = 1, binding = 0) uniform ScreenSizeBuffer
{
    float ScreenWidth;
    float ScreenHeight;
    vec2 Padding_;
};

const float maxSphereRadius = 100.0f;


layout (location = 0) out vec4 fsin_color;
layout (location = 1) out vec3 fsin_v_center;
layout (location = 2) out float fsin_radius;

void main()
{
    fsin_radius = min(maxSphereRadius, 5*length(Particles[gl_VertexIndex].Velocity));
    
    gl_PointSize =  2.0 + ceil(2.0*fsin_radius);
    gl_Position = vec4(Particles[gl_VertexIndex].Position / vec2(ScreenWidth, ScreenHeight), 0, 1);
    gl_Position.xy = 2 * (gl_Position.xy - vec2(0.5, 0.5));

    fsin_v_center.x = Particles[gl_VertexIndex].Position.x;
    fsin_v_center.y = ScreenHeight - Particles[gl_VertexIndex].Position.y;
    fsin_v_center.z = 0.5;

    fsin_color = Particles[gl_VertexIndex].Color;
}
