#version 450

layout(set = 0, binding = 0) uniform LightInfo
{
    vec3 LightDirection;
    float padding0;
    vec3 CameraPosition;
    float padding1;
};

layout(set = 1, binding = 0) uniform texture2DArray Tex;
layout(set = 1, binding = 1) uniform sampler Samp;

layout(location = 0) in vec3 fsin_Position_WorldSpace;
layout(location = 1) in vec3 fsin_Normal;
//layout(location = 2) in vec3 fsin_TexCoord;
layout (location = 2) in vec4 fsin_Color;
layout (location = 3) in vec3 fsin_v_center;
layout (location = 4) in float fsin_radius;

layout(location = 0) out vec4 outputColor;

void main()
{
//    vec3 p = (gl_FragCoord.xyz - fsin_v_center.xyz)/fsin_radius;
//    float z = 1.0 - length(p);
//    if (z < -1000.0) discard;
//  
//    gl_FragDepth = 0.5*fsin_v_center.z + 0.5*(1.0 - z);
    vec4 texColor = fsin_Color; //texture(sampler2DArray(Tex, Samp), fsin_TexCoord);

    float diffuseIntensity = clamp(dot(fsin_Normal, -LightDirection), 0, 1);
    vec4 diffuseColor = texColor * diffuseIntensity;

    // Specular color
    vec4 specColor = vec4(0, 0, 0, 0);
    vec3 lightColor = vec3(1, 1, 1);
    float specPower = 5.0f;
    float specIntensity = 0.3f;
    vec3 vertexToEye = -normalize(fsin_Position_WorldSpace - CameraPosition);
    vec3 lightReflect = normalize(reflect(LightDirection, fsin_Normal));
    float specularFactor = dot(vertexToEye, lightReflect);
    if (specularFactor > 0)
    {
        specularFactor = pow(abs(specularFactor), specPower);
        specColor = vec4(lightColor * specIntensity * specularFactor, 1.0f) * texColor;
    }

    outputColor = diffuseColor + specColor;
  //  outputColor *= 0.5;
  //  outputColor += 0.5*fsin_Color;
}
