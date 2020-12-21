#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout(set = 0, binding = 1) uniform ProjView
{
    mat4 View;
    mat4 Proj;
};

layout(set = 0, binding = 2) uniform RotationInfo
{
    float LocalRotation;
    float GlobalRotation;
    vec2 padding0;
};

layout(location = 0) in vec3 Position;
layout(location = 1) in vec3 Normal;
layout(location = 2) in vec2 TexCoord;

layout(location = 3) in vec3 InstancePosition;
layout(location = 4) in vec3 InstanceScale;

layout(location = 5) in vec3 InstanceColor;

layout(location = 0) out vec3 fsin_Position_WorldSpace;
layout(location = 1) out vec3 fsin_Normal;
layout(location = 2) out vec4 fsin_Color;
layout (location = 3) out vec3 fsin_v_center;
layout (location = 4) out float fsin_radius;

void main()
{
    mat3 scalingMat = mat3(InstanceScale.x, 0, 0, 0, InstanceScale.y, 0, 0, 0, InstanceScale.z);

    vec3 transformedPos = (scalingMat * Position) + InstancePosition;
    vec4 pos = vec4(transformedPos, 1);
    fsin_Position_WorldSpace = transformedPos;
    gl_Position = Proj * View * pos;

    fsin_Normal = normalize(Normal);

    fsin_Color = vec4(InstanceColor, 1);
}
