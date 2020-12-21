#version 450
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

#define HASHSCALE3 vec3(443.897, 441.423, 437.195)

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
//layout(location = 4) in vec3 InstanceRotation;
layout(location = 4) in vec3 InstanceScale;
layout(location = 5) in int InstanceTexArrayIndex;

layout(location = 0) out vec3 fsin_Position_WorldSpace;
layout(location = 1) out vec3 fsin_Normal;
//layout(location = 2) out vec3 fsin_TexCoord;
layout(location = 2) out vec4 fsin_Color;
layout (location = 3) out vec3 fsin_v_center;
layout (location = 4) out float fsin_radius;

// Hash function by Dave Hoskins (https://www.shadertoy.com/view/4djSRW)
float hash33(vec3 p3)
{
    p3 = fract(p3 * HASHSCALE3);
    p3 += dot(p3, p3.yxz + vec3(19.19, 19.19, 19.19));
    return fract((p3.x + p3.y) * p3.z + (p3.x + p3.z) * p3.y + (p3.y + p3.z) * p3.x);
}

void main()
{
/**
    float cosX = cos(InstanceRotation.x);
    float sinX = sin(InstanceRotation.x);
    mat3 instanceRotX = mat3(
        1, 0, 0,
        0, cosX, -sinX,
        0, sinX, cosX);

    float cosY = cos(InstanceRotation.y + LocalRotation);
    float sinY = sin(InstanceRotation.y + LocalRotation);
    mat3 instanceRotY = mat3(
        cosY, 0, sinY,
        0, 1, 0,
        -sinY, 0, cosY);

    float cosZ = cos(InstanceRotation.z);
    float sinZ = sin(InstanceRotation.z);
    mat3 instanceRotZ =mat3(
        cosZ, -sinZ, 0,
        sinZ, cosZ, 0,
        0, 0, 1);

    mat3 instanceRotFull = instanceRotZ * instanceRotY * instanceRotZ;
**/

    mat3 scalingMat = mat3(InstanceScale.x, 0, 0, 0, InstanceScale.y, 0, 0, 0, InstanceScale.z);

/**
    float globalCos = cos(-GlobalRotation);
    float globalSin = sin(-GlobalRotation);

    mat3 globalRotMat = mat3(
        globalCos, 0, globalSin,
        0, 1, 0,
        -globalSin, 0, globalCos);

    vec3 transformedPos = (scalingMat * instanceRotFull * Position) + InstancePosition;
    transformedPos = globalRotMat * transformedPos;
**/
    vec3 transformedPos = (scalingMat * Position) + InstancePosition;
    vec4 pos = vec4(transformedPos, 1);
    fsin_Position_WorldSpace = transformedPos;
    gl_Position = Proj * View * pos;

//    fsin_Normal = normalize(globalRotMat * instanceRotFull * Normal);

    fsin_Normal = normalize(Normal);

//    fsin_TexCoord = vec3(TexCoord, InstanceTexArrayIndex);

    //float rnd = hash33(fsin_Normal.xyz);

//    fsin_Color = vec4(0.5+0.5*rnd, (1-rnd)*0.5+0.5, 0.75, 1);
    fsin_Color = vec4(fsin_Normal, 1);
   // fsin_v_center = gl_Position.xyz;
   // fsin_radius =  2.0 + ceil( (cosZ+1)*4.0);
  //  gl_PointSize =  fsin_radius;

    
}
