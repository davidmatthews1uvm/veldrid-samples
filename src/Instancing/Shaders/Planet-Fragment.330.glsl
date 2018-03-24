#version 330 core

uniform LightInfo
{
    vec3 LightDirection;
    float padding0;
    vec3 CameraPosition;
    float padding1;
};

uniform sampler2D Tex;

in vec3 fsin_Position_WorldSpace;
in vec3 fsin_Normal;
in vec2 fsin_TexCoord;

out vec4 outputColor;

void main()
{
    vec4 texColor = texture(Tex, fsin_TexCoord);

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
}
